# Arxiv paper renamer – pre-2007 format
#
#   Instructions:
#     1) Add any desired arXiv categories to the $Cats variable below as shown
#     2) Choose an overall path and edit $Path accordingly 
#     3) Place pdfs in folders named for the corresponding categories ("hep-th", etc) in the specified path
#     4) If necessary "gem install nokogiri"
#     5) Run the script

require 'nokogiri'
require 'open-uri'

$Cats = ["hep-th", "hep-ph", "quant-ph"]
$Path = "/Users/myName/Desktop/ARXIV_SORT/"

class ArXivCat
  def initialize(ident)
    @ident, @path = ident, $Path + ident + "/"
  end
    
  def search
    ent = Dir.entries(@path)
    puts "Searching in #{@ident} directory '#{@path}'...\n\n"
    n = 0
    
    ent.each{ |x|
      if x =~ /\d\d\d\d\d\d\d\.pdf|\d\d\d\d\d\d\dv.\.pdf/
      # if filename x has format '0000000.pdf' or '0000000v1.pdf'
      
        titlecode = x.gsub(/\.pdf/, "")
        arxTitle = Nokogiri::HTML(open("http://arxiv.org/abs/#{@ident}/#{titlecode}")).at_css "title"
        titStr = arxTitle.to_s.gsub(/<\/title>|<title>|\$|\n/,"").sub(/\[(.*?)\]./,"").gsub(/:/," –").gsub(/\//,":").gsub(/\s\s/," ")

        spacer = ""
        spacer = "  " if titlecode.length == 7
        puts "Found one! ArXiv code #{titlecode},#{spacer} Title: '#{ titStr.gsub(/:/, "/") }'"
  
        File.rename(@path + x, @path + titStr + ".pdf")

        n += 1
      end
    }
    
    puts "\n...Done. In total, we renamed #{n} arXiv articles out of #{ent.length} files checked.\n" if n > 0
    puts "No stray #{@ident} arXiv articles found." if n == 0
  end
end

$Cats.each { |x| ArXivCat.new(x).search }


# The regex substitutions in titStr definition do the following:
#   1) Remove <title>, </title> and an unwanted newline. Also remove $ which usually delineate formulas for LaTeX.
#   2) Remove the arXiv identifier, plus one extra space: '[0000.0000v0] '
#   3) Turn ':' into ' -'. Semicolons aren't allowed in filenames so next best option is to change 'Thing: Thingie' to 'Thing - Thingie'
#   4) Turn '/' into ':'. File.rename balks (at least on a mac) when the second arg contains '/', but if it receives ':' instead it replaces it with '/'
#   5) Replace any instances of double spaces '  ' with a single space ' '.
