class Sky
  API_URL = "http://partners.api.skyscanner.net/apiservices/"

  class << self
    def country
      "GB"
    end

    def currency
      "GBP"
    end

    def locale
      "en-GB"
    end

    def api_prefix
      "#{country}/#{currency}/#{locale}/"
    end

    #@TODO need mining
    def cheapest_quotes(origin: "anywhere", destination: "anywhere", start_at: "anytime", end_at: "anytime")
      request_uri = "#{API_URL}browsequotes/v1.0/#{api_prefix}#{origin}/#{destination}/#{start_at}/#{end_at}?apiKey=#{SKY_API_KEY}"
      response = RestClient.get request_uri
      Hash.from_xml(response)["BrowseQuotesResponseAPIDto"]["Quotes"]["QuoteDto"]
    end

    #@FIXME NSFW
    def cheapest_price_by_route(origin, destination, start_at: "anytime", end_at: "anytime")
      request_uri = "#{API_URL}browseroutes/v1.0/#{api_prefix}#{origin}/#{destination}/#{start_at}/#{end_at}?apiKey=#{SKY_API_KEY}"
      response = RestClient.get request_uri
      Hash.from_xml(response)#["BrowseQuotesResponseAPIDto"]["Quotes"]
    end

    def cheapest_price_by_date(origin, destination, start_at: "anytime", end_at: "anytime")
      request_uri = "#{API_URL}browsedates/v1.0/#{api_prefix}#{origin}/#{destination}/#{start_at}/#{end_at}?apiKey=#{SKY_API_KEY}"
      response = RestClient.get request_uri
      Hash.from_xml(response)["BrowseDatesResponseApiDto"]["Dates"]
    end

    #@FIXME JUST ANOTHER NSFW
    def grid_of_price_by_date(origin, destination, start_at: "anytime", end_at: "anytime")
      request_uri = "#{API_URL}browsegrid/v1.0/#{api_prefix}#{origin}/#{destination}/#{start_at}/#{end_at}?apiKey=#{SKY_API_KEY}"
      response = RestClient.get request_uri
      Hash.from_xml(response)
    end
  end
end