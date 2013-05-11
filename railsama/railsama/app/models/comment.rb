class Comment < ActiveRecord::Base
  belongs_to :ama	
	attr_accessible :body
	attr_accessible :unique_id
	attr_accessible :parent_id
	attr_accessible :author
end
