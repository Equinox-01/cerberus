# frozen_string_literal: true

require 'securerandom'
require 'concurrent-ruby'
require 'etc'

# SecureFileEraser securely deletes files by overwriting them with random data.
class SecureFileEraser
  def initialize(file_paths)
    @file_paths = file_paths
    @thread_count = Etc.nprocessors
    @pool = Concurrent::FixedThreadPool.new(@thread_count)
  end

  def erase_files
    futures = @file_paths.map do |file_path|
      Concurrent::Promises.future_on(@pool) do
        erase_file_or_large_file(file_path)
      end
    end

    futures.each(&:value)
    @pool.shutdown
    @pool.wait_for_termination
  end

  private

  def erase_file_or_large_file(file_path)
    raise "File #{file_path} does not exist." unless File.exist?(file_path)

    file_size = File.size(file_path)
    if file_size > 10 * 1024 * 1024
      erase_large_file(file_path)
    else
      erase_file(file_path)
    end
    File.delete(file_path)
  rescue Errno::EACCES
    raise "Permission denied for file #{file_path}"
  rescue StandardError => e
    raise "Failed to delete file #{file_path}: #{e.message}"
  end

  def erase_file(file_path)
    file_operation_in_blocks(file_path) do |file|
      erase_patterns.each { |pattern| overwrite_with_value(file, File.size(file_path), pattern) }
    end
  end

  def erase_large_file(file_path)
    file_size = File.size(file_path)
    block_size = file_size / @thread_count

    threads = @thread_count.times.map do |i|
      Thread.new do
        start_pos = i * block_size
        end_pos = i == @thread_count - 1 ? file_size : (i + 1) * block_size
        file_operation_in_range(file_path, start_pos, end_pos) do |file|
          erase_patterns.each { |pattern| overwrite_with_value_in_range(file, start_pos, end_pos, pattern) }
        end
      end
    end

    threads.each(&:join)
  end

  def file_operation_in_blocks(file_path, &block)
    File.open(file_path, 'r+b', &block)
  end

  def file_operation_in_range(file_path, start_pos, _end_pos)
    File.open(file_path, 'r+b') do |file|
      file.seek(start_pos)
      yield(file)
    end
  end

  def overwrite_with_value(file, size, value)
    file.rewind
    (size / 1024 / 1024).times { file.write(value) }
    remaining_bytes = size % (1024 * 1024)
    file.write(value[0, remaining_bytes]) if remaining_bytes.positive?
    file.flush
  end

  def overwrite_with_value_in_range(file, start_pos, end_pos, value)
    file.seek(start_pos)
    size = end_pos - start_pos
    (size / 1024 / 1024).times { file.write(value) }
    remaining_bytes = size % (1024 * 1024)
    file.write(value[0, remaining_bytes]) if remaining_bytes.positive?
    file.flush
  end

  def erase_patterns
    [
      SecureRandom.random_bytes(1024 * 1024),
      "\x00" * 1024 * 1024,
      "\xFF" * 1024 * 1024
    ]
  end
end
