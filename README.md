# Automated google-dorking with Ruby
# Requirements
To make this program work you need to install ruby 
(https://www.ruby-lang.org/en/downloads/) and ruby gems 
(https://rubygems.org/pages/download)
# Install gems
gem install google-search<br/>
gem install open-uri<br/>
gem install uri<br/>
gem install exiftool<br/>
#Run the program
ruby google-dork.rb [url you want to scope it down to] [the file extension you want to 
check for] [1 or 0, 1 downloads all the hits, 0 just run the exiftool on the already downloaded files]
#Further work
This program is just a program to show how it is possible to automate downloading and check
all the files for metadata. All the files are stored in /tmp/