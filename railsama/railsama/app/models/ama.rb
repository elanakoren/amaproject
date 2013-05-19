require 'rubygems'
require 'json'
require 'net/http'
require 'comment'
require 'snoo'

class Ama < ActiveRecord::Base
  attr_accessible :author, :url, :title, :date, :threadhash
  has_many :comments, :dependent => :destroy
  
  def download
    if date.nil? or Time.now - date > 60 # don't hit the same thread more than once per minute
      result = JSON.parse(Net::HTTP.get_response(URI.parse(url + ".json")).body)
      h = {:author => result[0]['data']['children'][0]['data']['author'], :title => result[0]['data']['children'][0]['data']['title'],
         :date => Time.now, :threadhash => result[0]['data']['children'][0]['data']['name']}
      self.update_attributes(h)
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
  
  def self.topthree()
     reddit = Snoo::Client.new
     toplink = reddit.get_listing({:subreddit =>"IAMA", :page=>"top", :t =>"day", :limit=>1})
     parse_me = toplink['data']['children'][0]['data']['url'] + ".json"
     result = JSON.parse(Net::HTTP.get_response(URI.parse(parse_me)).body)
     @topama = Ama.find_or_create_by_threadhash(result[0]['data']['children'][0]['data']['name'])
     h = {:author => result[0]['data']['children'][0]['data']['author'], :title => result[0]['data']['children'][0]['data']['title'],
        :date => Time.now, :threadhash => result[0]['data']['children'][0]['data']['name'],
        :url => result[0]['data']['children'][0]['data']['url']}
     @topama.update_attributes(h)
     @topama.toplevel(result)
   end
end
