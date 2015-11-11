# coding: utf-8
require 'rubygems'
require 'google-search'
require 'open-uri'
require 'uri'
require 'exiftool'

unless ARGV.length == 3
  puts "Dude, not the right number of arguments."
  puts "Usage: ruby google-make-list.rb url dork 0|1\n"
  exit
end

url  = ARGV[0]
dork = ARGV[1]
download = ARGV[2]
html_file = File.open("/tmp/metadata.html", "w")

if download == "1"
  p "Ok, we'll download the files too"
  results = Google::Search::Web.new(query: "site:#{url} filetype:#{dork}")
  
  results.each do |result|
    p result.uri
    uri = URI(result.uri)
    filename = URI(uri).path.split('/').last
    download = open(uri)
    IO.copy_stream(download, "/tmp/#{filename}")
  end
else
  p "Not going to download the files, only run exiftool on existing #{dork} files"
end

html_file.write("<html><title>Metadata</title><body>")

Dir.glob("/tmp/*.#{dork}") do |file|
  html_file.write("<table border=\"solid\"><th>Filename: <a href=\"#{file}\">#{file}:</a></th><th>Data</th>")
  e = Exiftool.new(file)
  data = e.to_hash
  
  for key in data.keys()
    html_file.write("<tr><td>#{key}</td><td>#{data[key]}</td></tr>")
  end
  
  html_file.write("</table>")  
end

html_file.write("</body></html>")
html_file.close unless html_file.nil?
