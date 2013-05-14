require 'rubygems'
require 'json'
require 'net/http'
require 'comment'

class Ama < ActiveRecord::Base
  attr_accessible :author, :url, :title, :date
  has_many :comments, :dependent => :destroy
  
  def download
    if date.nil? or Time.now-date > 60 # don't hit the same thread more than once per minute
      result = JSON.parse(Net::HTTP.get_response(URI.parse(url + ".json")).body)
      self.author = result[0]['data']['children'][0]['data']['author']
      self.title = result[0]['data']['children'][0]['data']['title']
      self.date = Time.now
      toplevel(result)
    end
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
    comment = Comment.find_or_create_by_unique_id(thread['name'])
    comment.update_attributes(h)
    comment.ama = self
    comment.save
  end
end
