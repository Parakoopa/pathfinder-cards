require 'csv'
require 'nokogiri'
require 'set'
require_relative 'crawl_spellcard_webinfos'

# This is there, so that nested hashes can be defined rescursively way easier.
class Hash
  def self.recursive
    new {|hash, key| hash[key] = recursive}
  end
end


class SpellDataCrawler

  def initialize
    @endresult = Hash.recursive
  end

  def parse_data(path_to_csv)
    CSV.foreach(path_to_csv, :headers => true) do |row|
      name = filter_out_label(row['Name']).to_s
      link = filter_out_link(row['Name'])[0].to_s
      klasse_und_grad = format_class_and_spell_level(row['Grad'])
      schule = row['Schule']
      unterschule = row['Unterschule']
      kategorie = row['Kategorie']
      beschreibung = row['Beschreibung']
      regelwerk = row['Regelwerk']
      seite = row['Seite']

      append_to_endresult(name, link, klasse_und_grad, schule, unterschule, kategorie, beschreibung, regelwerk, seite)
    end
    puts @endresult
  end

  private

  def filter_out_link(html_string)
    link_inside = Nokogiri::HTML.parse(html_string)
    return link_inside.css('a').map {|link| link['href']}
  end

  private

  def filter_out_label(html_string)
    text_inside = Nokogiri::HTML.parse(html_string)
    text_inside.text
  end

  private

  # @param [string] info_string
  # @return map
  def format_class_and_spell_level(info_string)
    class_and_spells = {}
    info_string.split(',').each do |elem|
      val = elem.split(' ')
      if val[0] == "Elementarmagier"
        val[0] = val[0] + " " + val[1] # because they are subdivided in their elemental nonsense
        class_and_spells[val[0]] = val[2]
        next
      end
      if val[0] == "Hexenmeister/Magier"
        casters = val[0].split('/')
        class_and_spells[casters[0]] = val[1]
        class_and_spells[casters[1]] = val[1]
        next
      end
      class_and_spells[val[0]] = val[1]
    end
    class_and_spells
  end

  private

  # @param [string] name
  # @param [string] link
  # @param [Hash] klasse_grad
  # @param [string] schule
  # @param [string] unterschule
  # @param [string] kategorie
  # @param [string] beschreibung
  # @param [string] regelwerk
  # @param [string] seite
  def append_to_endresult(name, link, klasse_grad, schule, unterschule, kategorie, beschreibung, regelwerk, seite)
    webcrawler = Spellwebcrawler.new
    infos = {"kategorie" => kategorie, "beschreibung" => beschreibung, "regelwerk" => regelwerk, "seite" => seite}

    klasse_grad.each do |klasse, grad|
      # Restricted for now, for testing purpose
      if klasse == "Okkultist"
        additional_infos = webcrawler.crawl_spell(link)
        infos =infos.merge(additional_infos)
      end
      if klasse.include? "Elementarmagier"
        if klasse.include? "(Allgemein)"
          if unterschule == nil
            @endresult["Magier"]["Spezialisierungen"]["Elementarmagier (Feuer)"][grad][schule][name] = infos
            @endresult["Magier"]["Spezialisierungen"]["Elementarmagier (Luft)"][grad][schule][name] = infos
            @endresult["Magier"]["Spezialisierungen"]["Elementarmagier (Erde)"][grad][schule][name] = infos
            @endresult["Magier"]["Spezialisierungen"]["Elementarmagier (Wasser)"][grad][schule][name] = infos
          else
            @endresult["Magier"]["Spezialisierungen"]["Elementarmagier (Feuer)"][grad][schule][unterschule][name] = infos
            @endresult["Magier"]["Spezialisierungen"]["Elementarmagier (Luft)"][grad][schule][unterschule][name] = infos
            @endresult["Magier"]["Spezialisierungen"]["Elementarmagier (Erde)"][grad][schule][unterschule][name] = infos
            @endresult["Magier"]["Spezialisierungen"]["Elementarmagier (Wasser)"][grad][schule][unterschule][name] = infos
          end
        end
      else
        if unterschule == nil
          @endresult[klasse][grad][schule][name] = infos
        else
          @endresult[klasse][grad][schule][unterschule][name] = infos
        end
      end
    end
  end

end

crawler = SpellDataCrawler.new

crawler.parse_data('data/spelldata.csv')
