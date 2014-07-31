# From main page, crawl the links to the chapter headings.

# pattern: <a href="/mgp/content/\d{3}.*>

# click on it
# look for printpdf in link - and retrieve it.

#stitch according to Charles' list

require 'httpclient'
require 'getoptlong'
require 'nokogiri'
require 'open-uri'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--url', '-u', GetoptLong::REQUIRED_ARGUMENT]
)

def error_exit(msg)
  puts "Error found... exiting ..."
  puts msg
  exit -1
end

def print_help_and_exit
  puts <<EOS
  #{__FILE__} [options]

  Options:
    -u, --url: URL to download

EOS
  exit 0
end

url = ''

opts.each do |opt, arg|
   case opt
     when '--help'
     print_help_and_exit

     when '--url'
     url = arg.to_s
   end
end

if url == ''
  print_help_and_exit
end

class WebpageCrawler

  def initialize(url)
    @url = url
    client = HTTPClient.new
    content = client.get_content(@url)

    matches = /(http.?:\/\/[^\\]+)\//.match @url
    @base = matches[1]
    @dom_root = Nokogiri::HTML(content)
  end

  def links
    list = []
    @dom_root.css('a').each do |e|
      if (block_given?)
        select = yield e
      else
        select = true
      end
      if select
        list << e
      end
    end

    list
  end

  def root
    @dom_root
  end
end

crawler = WebpageCrawler.new url

root = crawler.root
list_top = root.css('ul.jquerymenu')

def get_sections(ul_elt)

  ul_elt.children.each do |section_li|
    title = section_li.css('a')[0]['title']
    if !(/Building Decriptors Reference/.match title)
      puts section_li.css('a')[0]['href']
    else # This is section 6 - get its children
      get_sections(section_li.css('ul')[0])
    end
  end
end

list_top.children.each do |c|
  if c.node_name == 'li'
    puts c.css('a')[0]['href']
    get_sections(c.css('ul')[0])
  end
end


