require 'bluecloth'
module AmasHelper
  def m(string)
    BlueCloth.new(string).to_html()
  end
end
