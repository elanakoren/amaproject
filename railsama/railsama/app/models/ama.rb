require 'rubygems'
require 'json'
require 'net/http'
require 'comment'

class Ama < ActiveRecord::Base
  attr_accessible :author, :url, :title
  has_many :comments
  
  def update
    result = JSON.parse(Net::HTTP.get_response(URI.parse(url + ".json")).body)
    author = result[0]['data']['children'][0]['data']['author']
    title = result[0]['data']['children'][0]['data']['title']
    toplevel(result)
  end
  
   def toplevel(result)    
     result[1]['data']['children'].each do |x|
       traverse_thread(x['data'], nil)
   	end
  end
  
  def traverse_thread(thread, parent)
    if thread['author'] == author
      create_comment(parent) if parent
      create_comment(thread)
    end
    unless thread['replies'].nil? or thread['replies']['data'].nil?
      thread['replies']['data']['children'].each do |reply|
        traverse_thread(reply['data'], thread)
      end
    end
  end
  
  def create_comment(thread)
    h = {:body => thread['body'], :unique_id => thread['name'], :parent_id => thread['parent_id'], :author => thread['author']}
    comment = Comment.new(h)
    comment.ama = self
    comment.save
  end
end
