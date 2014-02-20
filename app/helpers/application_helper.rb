module ApplicationHelper
  def gbp(price)
    number_to_currency(price, :unit => "£")
  end
end
