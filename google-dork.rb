# coding: utf-8
require 'rubygems'
require 'google-search'
#require 'open-uri'
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
$full_uri_to_file = ""

if download == "1"
  p "Ok, we'll download the files too"
  results = Google::Search::Web.new(query: "site:#{url} filetype:#{dork}")
  
  results.each do |result|
    p result.uri
    
    uri = URI(result.uri)
    $full_uri_to_file = uri
    filename = URI(uri).path.split('/').last
    begin
      download = open(uri)
      IO.copy_stream(download, "/tmp/#{filename}")
    rescue OpenURI::HTTPError => e
      puts "Can't access #{ url }"
      puts e.message
      puts
      next
    end
  end
else
  p "Not going to download the files, only run exiftool on existing #{dork} files"
end

html_file.write("<html><meta charset=\"UTF-8\"><title>Metadata</title><body>")

Dir.glob("/tmp/*.#{dork}") do |file|
  html_file.write("<br/><br/>")
  html_file.write("<table border=\"solid\"><th>Nr</th><th>Filename: <a href=\"#{file}\">#{file}:</a></th><th>Url to original: #{$full_uri_to_file}</th>")
  e = Exiftool.new(file)
  data = e.to_hash
  counter = 1
  for key in data.keys()
    html_file.write("<tr><td>#{counter}</td><td>#{key}</td><td>#{data[key]}</td></tr>")
    counter+=1
  end
  
  html_file.write("</table>")  
end

html_file.write("</body></html>")
html_file.close unless html_file.nil?
