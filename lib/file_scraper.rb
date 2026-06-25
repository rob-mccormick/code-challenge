# frozen_string_literal: true

require "ferrum"
require "json"
require "nokogiri"

class FileScraper
  DOMAIN_NAME = "https://www.google.com"

  def self.run(file_path)
    html = extract_html(file_path)

    document = Nokogiri::HTML(html)

    artworks = document.css("g-loading-icon + div").children

    result = artworks.map do |artwork|
      extensions = artwork.css("img + div").children.map do |extension|
        extension.text if extension && !extension.text.empty?
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
      }
    end

    JSON.generate(artworks: result)
  end

  private

  def self.extract_html(file_path)
    file_extension = file_path.split(".").last

    raise "Please use an HTML file" unless file_extension == "html"

    begin
      browser = Ferrum::Browser.new
      browser.go_to("file:///#{File.expand_path(file_path)}")
      browser.body
    ensure
      browser.quit
    end
  end
end
