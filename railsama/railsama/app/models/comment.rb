class Comment < ActiveRecord::Base	
	attr_accessible :body
	attr_accessible :unique_id
	attr_accessible :parent_id
	attr_accessible :author
	belongs_to :ama
end
