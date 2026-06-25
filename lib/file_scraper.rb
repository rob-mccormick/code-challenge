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
      extensions = artwork.css(".KHK6lb > div").map do |extension|
        extension&.text unless extension&.text.empty?
      end
      name = extensions.shift
      relative_path = artwork.at("a")["href"]
      data_image = artwork.at("img")["data-src"]
      src_image = artwork.at("img")["src"]
      {
        name:,
        extensions: (extensions unless extensions.compact.empty?),
        link: DOMAIN_NAME + relative_path,
        image: data_image || src_image,
      }.compact
    end

    JSON.generate({artworks: result})
  end
end
