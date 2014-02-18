class PagesController < ApplicationController

  before_action :can_visit?, except: :welcome

  def index
  end

  def welcome
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
