require 'spec_helper'

describe AirportsController do

  describe "GET 'autocomplete'" do
    it "returns http success" do
      get 'autocomplete'
      response.should be_success
    end
  end

end
