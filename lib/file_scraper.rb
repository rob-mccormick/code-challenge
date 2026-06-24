# frozen_string_literal: true

require "nokogiri"
require "json"

class FileScraper
  def self.get(file_path)
    html = File.read(file_path)

    raise "The file has no content" if html.nil?

    document = Nokogiri::HTML(html)

    JSON.generate({})
  end
end
