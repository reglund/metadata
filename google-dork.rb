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


Dir.glob("/tmp/*.#{dork}") do |file|  
  e = Exiftool.new(file)
  data = e.to_hash
  
  for key in data.keys()
    print key, " : (", data[key], ")\n"
  end

  # p "=================================================="
  # p "Organization (#{e[:organization]})"
  # p "Mail address (#{e[:mail_address]})"
  # p "Created date (#{e[:create_date]})"
  # p "Author (#{e[:author]})"
  # p "Creator (#{e[:creator]})"
  # p "Gpslatitude (#{e[:gps_latitude]})"
  # p "Gpslongitude (#{e[:gps_longitude]})"
  # p "Directory (#{e[:directory]})"
  # p "Last modified by (#{e[:last_modified_by]})"
  # p "GPS Latitude Ref (#{e[:gps_latitude_ref]})"
  # p "GPS Longitude Ref (#{e[:gps_longitude_ref]})"
  # p "GPS Time Stamp (#{e[:gps_time_stamp]})"
  # p "GPS (#{e[:gps_latitude_ref]})"
  # p "GPS Latitude ref (#{e[:gps_latitude_ref]})"
  
end
