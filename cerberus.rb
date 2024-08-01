require 'fileutils'
require 'benchmark'
require_relative 'secure_file_eraser'

class Cerberus
  def initialize(file_paths)
    @file_paths = file_paths
  end

  def run
    if @file_paths.empty?
      puts "No files or directories specified."
      exit 1
    end

    time = Benchmark.measure do
      all_files = expand_directories(@file_paths)
      begin
        eraser = SecureFileEraser.new(all_files)
        puts "Processing ..."
        eraser.erase_files
        clean_directories(@file_paths)
      rescue => e
        puts "An error occurred: #{e.message}"
        exit 1
      end
    end

    puts "All files have been securely deleted."
    puts "Time elapsed - #{time.real.to_i} seconds"
  end

  private

  def expand_directories(paths)
    files = []
    paths.each do |path|
      if File.directory?(path)
        Dir.glob("#{path}/**/*").each do |file|
          files << file if File.file?(file)
        end
      else
        files << path if File.file?(path)
      end
    end
    files
  end

  def clean_directories(paths)
    paths.each do |path|
      if File.directory?(path)
        begin
          FileUtils.remove_dir(path)
          puts "Directory #{path} has been securely deleted."
        rescue Errno::EACCES
          puts "Permission denied for directory #{path}"
        rescue => e
          puts "Failed to delete directory #{path}: #{e.message}"
        end
      end
    end
  end
end

cerberus = Cerberus.new(ARGV)
cerberus.run
