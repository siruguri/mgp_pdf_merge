require 'httpclient'
require 'nokogiri'

if ARGV[0]
  purpose_number = ARGV[0]
else 
  purpose_number = 0
end

f = File.open('section_list.txt')

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

end

class PdfList
  def initialize
    @actual_section_count = 0
    @base = 'http://www.comnet.org'
    @made_up_count = 0
    @all_sections_counter = 0
  end

  def get_printpdf(l, purpose_number=0)
    l="#{@base}#{l}"
    puts "Fetching #{l}"
    matches = /content.(\d+)\-/.match l

    if matches.nil?
      section_number = "#{@actual_section_count}_#{@made_up_count}"
      @made_up_count += 1
    else
      section_number = matches[1]
      @actual_section_count = section_number.to_i
      @made_up_count = 0
    end

    crawler = WebpageCrawler.new l

    links =  crawler.links do  |lk|
      /print\//.match(lk['href'])
    end
    links.each do |lk|
      unless /\/2$/.match lk['href']
        matches = /(\d+)$/.match lk['href']
        book_number = matches[1]
        puts "xvfb-run --server-args=\"-screen 0, 1024x768x24\" wkhtmltopdf  'http://www.comnet.org#{lk['href']}?purpose=#{purpose_number}' #{sprintf('%02d', @all_sections_counter)}_#{section_number}_#{book_number}.pdf"
        puts "sleep 2 #wkhtmltopdf"
        @all_sections_counter += 1
      end
    end
  end
end    

fetcher = PdfList.new

last_known_section=0
f.readlines.each do |line|
  if !(/\#/.match line)
    last_known_section = fetcher.get_printpdf line, purpose_number
  end
end

