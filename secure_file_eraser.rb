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
    futures = @file_paths.map do |file_path|
      Concurrent::Promises.future_on(@pool) do
        begin
          if File.exist?(file_path)
            erase_file(file_path)
            File.delete(file_path)
            puts "File #{file_path} has been securely deleted."
          else
            puts "File #{file_path} does not exist."
          end
        rescue Errno::EACCES
          puts "Permission denied for file #{file_path}"
        rescue => e
          puts "Failed to delete file #{file_path}: #{e.message}"
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
      overwrite_with_value(file, file_size, SecureRandom.random_bytes(1))
      overwrite_with_value(file, file_size, "\x00")
      overwrite_with_value(file, file_size, "\xFF")
    end
  end

  def overwrite_with_value(file, size, value)
    file.rewind
    size.times { file.write(value) }
    file.flush
  end
end
