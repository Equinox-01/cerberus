require 'fileutils'
require 'optparse'
require_relative 'secure_file_eraser'

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

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: cerberus.rb [options]"

  opts.on("-f", "--files FILES", "Comma-separated list of files and directories to erase") do |files|
    options[:files] = files
  end
end.parse!

if options[:files]
  file_paths = options[:files].split(',').map(&:strip)
  all_files = expand_directories(file_paths)
  eraser = SecureFileEraser.new(all_files)
  eraser.erase_files
  clean_directories(file_paths)
else
  puts "No files specified. Use -f or --files option to specify files and directories."
end
