class PagesController < ApplicationController
  def index
  end

  def add_airport_form
    respond_to do |format|
      format.js
    end
  end

  def remove_airport_form
    respond_to do |format|
      format.js
    end
  end
end
