# Arxiv paper renamer – modern format (2007-present)
#
#   Instructions:
#     1) Edit 'fromDir' to the path where your arXiv papers are located
#     2) Edit 'targetDir' to the place where you want the renamed papers to go
#     3) If necessary "gem install nokogiri"
#     4) Run the script

require 'nokogiri'
require 'open-uri'
require 'fileutils'

fromDir   = "/Users/yourname/Downloads/"
targetDir = "/Users/yourname/Desktop/ARXIV_SORT/"

ent = Dir.entries(fromDir)

puts "Beginning search in '#{fromDir}'...\n\n"
n = 0

ent.each { |x|
  if x =~ /\d\d\d\d\.\d\d\d\d\.pdf|\d\d\d\d\.\d\d\d\dv.\.pdf|\d\d\d\d\.\d\d\d\d\d\.pdf|\d\d\d\d\.\d\d\d\d\dv.\.pdf/

    titlecode = x.gsub(/\.pdf/, "")
    arxTitle = Nokogiri::HTML(open('http://arxiv.org/abs/' + titlecode)).at_css "title"
    titStr = arxTitle.to_s.gsub(/<\/title>|<title>|\$|\n/,"").sub(/\[(.*?)\]./,"").gsub(/:/," –").gsub(/\//,":").gsub(/\s\s/," ")

    # alignment offset for absent version number
    spacer = ""
    spacer = "  " if titlecode.length == 9

    puts "Found arXiv article #{titlecode},#{spacer} Title: '#{ titStr.gsub(/:/, "/") }'" # change ':' back to '/' for terminal readout

    FileUtils.cp(fromDir + x, targetDir)  
    File.rename(targetDir + x, targetDir + titStr + ".pdf")
    File.delete(fromDir + x)

    n += 1
  end
}

puts "\n...Done. In total, we found #{n} arXiv articles out of #{ent.length} files checked.\n" if n > 0
puts "All of them moved to '#{targetDir}'." if n > 0
puts "No stray ArXiv articles found." if n == 0


# The regex substitutions in titStr definition do the following:
#   1) Remove <title>, </title> and an unwanted newline. Also remove $ which usually delineate formulas for LaTeX.
#   2) Remove the arXiv identifier, plus one extra space: '[0000.0000v0] '
#   3) Turn ':' into ' -'. Semicolons aren't allowed in filenames so next best option is to change 'Thing: Thingie' to 'Thing - Thingie'
#   4) Turn '/' into ':'. File.rename balks (at least on a mac) when the second arg contains '/', but if it receives ':' instead it replaces it with '/'
#   5) Replace any instances of double spaces '  ' with a single space ' '.
