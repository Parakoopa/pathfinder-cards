require 'open-uri'
require 'nokogiri'

class Spellwebcrawler

  def initialize
    @values = []
  end


  def crawl_spell(url)
    content = crawl_spell_content(url)
    filtered_content = filter_spell(content)
    convert_spell_content(filtered_content)
  end

  private
    # @param [string] url
    def crawl_spell_content(url)
      fh = open(url)
      html = fh.read
      doc = Nokogiri::HTML(html)
      return doc.css('div#page p.auto')[1]
    end

  private
    # @param [Nokogiri::HTML::Document] spelldata
    def filter_spell(spelldata)
      spelldata.css('strong').each do |node|
        if node.text.include? 'Schule' or node.text.include? "Grad"
          node.remove
        end
      end
      spelldata.search("//strong/following-sibling::text()").each do |elem|
        if elem.to_s.length > 1
          @values.append(elem.to_s.gsub(/[[:space:]]/," "))
        end
      end
      @values.pop #because the last one is something we dont want
      return spelldata
    end

  private
    # @param [Nokogiri::HTML::Document] spelldata
    def convert_spell_content(spelldata)
      keys = []
      spelldata.css('strong').each do |elem|
        cleaned = elem.text.to_s.chomp(':')
        keys.append(cleaned)
      end
      Hash[keys.zip(@values)]
    end

end

bla = Spellwebcrawler.new
bla.crawl_spell('http://prd.5footstep.de/Grundregelwerk/Zauber/Ausbessern')

