require 'rdiscount'
require 'snoo'
require 'json'
require 'net/http'
module AmasHelper
  def m(string)
    RDiscount.new(string).to_html.html_safe
  end
  

end
