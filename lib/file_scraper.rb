# frozen_string_literal: true

require "nokogiri"
require "json"

class FileScraper
  DOMAIN_NAME = "https://www.google.com"

  def self.run(file_path)
    html = File.read(file_path)

    raise "The file has no content" if html.nil?

    document = Nokogiri::HTML(html)

    artworks = document.css(".iELo6")

    result = artworks.map do |artwork|
      extensions = artwork.css(".KHK6lb > div").map { it&.text }
      name = extensions.shift
      relative_path = artwork.at("a")["href"]
      image = artwork.at("img")["data-src"]
      {
        name:,
        extensions:,
        link: DOMAIN_NAME + relative_path,
        image:,
      }
    end

    JSON.generate({artworks: result})
  end
end

