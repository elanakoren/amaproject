class Comment < ActiveRecord::Base	
	attr_reader :unique_id
	attr_accessor :unique_id
	attr_accessible :parent_id, :author
end
