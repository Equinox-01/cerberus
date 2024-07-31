require 'securerandom'
require 'concurrent-ruby'
require 'etc'

class SecureFileEraser
  def initialize(file_paths)
    @file_paths = file_paths
    @thread_count = Etc.nprocessors
    @pool = Concurrent::FixedThreadPool.new(@thread_count)
  end

  def erase_files
    raise "Files does not exist." if @file_paths.empty?

    futures = @file_paths.map do |file_path|
      Concurrent::Promises.future_on(@pool) do
        begin
          if File.exist?(file_path)
            if File.size(file_path) > 10 * 1024 * 1024 # 10 MB
              erase_large_file(file_path)
            else
              erase_file(file_path)
            end
            File.delete(file_path)
          else
            raise "File #{file_path} does not exist."
          end
        rescue Errno::EACCES
          raise "Permission denied for file #{file_path}"
        rescue => e
          raise "Failed to delete file #{file_path}: #{e.message}"
        end
      end
    end

    futures.each(&:wait)
    @pool.shutdown
    @pool.wait_for_termination
  end

  private

  def erase_file(file_path)
    file_size = File.size(file_path)

    File.open(file_path, 'r+b') do |file|
      overwrite_with_value(file, file_size, -> { SecureRandom.random_bytes(1024 * 1024) })
      overwrite_with_value(file, file_size, -> { "\x00" * 1024 * 1024 })
      overwrite_with_value(file, file_size, -> { "\xFF" * 1024 * 1024 })
    end
  end

  def erase_large_file(file_path)
    file_size = File.size(file_path)
    block_size = file_size / @thread_count

    threads = @thread_count.times.map do |i|
      Concurrent::Promises.future_on(@pool) do
        start_pos = i * block_size
        end_pos = (i == @thread_count - 1) ? file_size : (i + 1) * block_size

        File.open(file_path, 'r+b') do |file|
          overwrite_with_value_in_range(file, start_pos, end_pos, -> { SecureRandom.random_bytes(1024 * 1024) })
          overwrite_with_value_in_range(file, start_pos, end_pos, -> { "\x00" * 1024 * 1024 })
          overwrite_with_value_in_range(file, start_pos, end_pos, -> { "\xFF" * 1024 * 1024 })
        end
      end
    end

    threads.each(&:wait)
  end

  def overwrite_with_value(file, size, value_proc)
    file.rewind
    (size / 1024 / 1024).times { file.write(value_proc.call) }
    remaining_bytes = size % (1024 * 1024)
    file.write(value_proc.call[0, remaining_bytes]) if remaining_bytes > 0
    file.flush
  end

  def overwrite_with_value_in_range(file, start_pos, end_pos, value_proc)
    file.seek(start_pos)
    size = end_pos - start_pos
    (size / 1024 / 1024).times { file.write(value_proc.call) }
    remaining_bytes = size % (1024 * 1024)
    file.write(value_proc.call[0, remaining_bytes]) if remaining_bytes > 0
    file.flush
  end
end
