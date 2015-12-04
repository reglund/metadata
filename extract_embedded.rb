#!/usr/bin/ruby
require 'exiftool'
require 'zip'
require 'fileutils'

def loop_over_files
  Dir.glob("/tmp/*.docx") do |file|  
    unzip_file(file,'/tmp/unpack')    
  end
end

def unzip_file (file, destination)
  puts "Unzipping #{file}"
  clean_up("/tmp/unpack/")
  Zip::File.open(file) do |zip_file|
    zip_file.each do |f|
      f_path = File.join(destination, f.name)
      FileUtils.mkdir_p(File.dirname(f_path))
      f.extract(f_path)
    end
  end
  extract_data()
end

def extract_data 
  puts "Extracting metadata"
  path = "/tmp/unpack/word/media/"
  $html_file.write("<html><meta charset=\"UTF-8\"><title>Metadata in embedded pictures</title><body>")

  Dir.glob("#{path}/*.jpg") do |file|
    puts "Running exiftool on #{file}"
    $html_file.write("<br/><br/>")
    $html_file.write("<table border=\"solid\"><th>Key</th><th>Value</th>")
    e = Exiftool.new(file)
    data = e.to_hash
    
    for key in data.keys()
      $html_file.write("<tr><td>#{key}</td><td>#{data[key]}</td></tr>")
    end
  end
end


def clean_up(dir)
  puts "Cleaning up"
  FileUtils.remove_dir(dir)
  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end
end

def init

end

$html_file = File.open("/tmp/metadata_embedded_pic.html", "a")

loop_over_files()
#unless File.basename(file) =~ /jpg|png|gif|modernizr|fancybox|jquery/
