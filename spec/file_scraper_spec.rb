# frozen_string_literal: true

require "file_scraper"

RSpec.describe FileScraper do
  before :all do
    path = "./files/van-gogh-paintings.html"
    json_response = FileScraper.get(path)
    @response = JSON.parse(json_response)
  end

  it "contains artworks array" do
    expect(@response["artworks"]).to be_a(Array)
  end

  it "artworks – name" do
    expect(@response["artworks"].first["name"]).to be_a(String)
    expect(@response["artworks"].first["name"]).not_to be_empty
  end

  it "artworks – extensions" do
    expect(@response["artworks"].first["extensions"]).to be_a(Array)
  end

  it "artworks – link" do
    expect(@response["artworks"].first["link"]).to be_a(String)
    expect(@response["artworks"].first["link"]).not_to be_empty
  end

  context "with thumbnail" do
    it "artworks – image" do
      expect(@response["artworks"].first["image"]).to be_a(String)
      expect(@response["artworks"].first["image"]).not_to be_empty
    end
  end

  context "without thumbnail" do
    it "artworks – image" do
      expect(@response["artworks"].last["image"]).to be_a(String)
      expect(@response["artworks"].last["image"]).not_to be_empty
    end
  end
end
