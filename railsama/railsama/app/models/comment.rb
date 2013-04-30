class Comment < ActiveRecord::Base	
	attr_accessible :body, :unique_id, :parent_id, :author
end
