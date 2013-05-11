class Ama < ActiveRecord::Base
  attr_accessible :author, :url
  has_many :comments
end
