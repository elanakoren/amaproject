require 'rdiscount'
module AmasHelper
  def m(string)
    RDiscount.new(string).to_html.html_safe
  end
end
