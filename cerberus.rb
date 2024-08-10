# frozen_string_literal: true

require 'fileutils'
require 'benchmark'
require_relative 'secure_file_eraser'

# Cerberus is a class that securely deletes files and directories specified by the user.
class Cerberus
  def initialize(file_paths)
    @file_paths = file_paths
  end

  def run
    validate_and_process_files
    puts 'All files have been securely deleted.'
  end

  private

  def validate_and_process_files
    if @file_paths.empty?
      puts 'No files or directories specified.'
      exit 1
    end

    time = Benchmark.measure do
      all_files = expand_directories(@file_paths)
      eraser = SecureFileEraser.new(all_files)
      puts 'Processing ...'
      eraser.erase_files
      clean_directories(@file_paths)
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      exit 1
    end

    puts "Time elapsed - #{time.real.to_i} seconds"
  end

  def expand_directories(paths)
    paths.flat_map do |path|
      if File.file?(path)
        path
      elsif File.directory?(path)
        Dir.glob("#{path}/**/*").select { |file| File.file?(file) }
      end
    end
  end

  def clean_directories(paths)
    paths.each do |path|
      FileUtils.remove_entry_secure(path, true) if File.directory?(path)
    rescue Errno::EACCES
      puts "Permission denied for directory #{path}"
    rescue StandardError => e
      puts "Failed to delete directory #{path}: #{e.message}"
    end
  end
end

cerberus = Cerberus.new(ARGV)
cerberus.run
