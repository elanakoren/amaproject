require 'rubygems'
require 'json'
require 'net/http'
require 'pp'
require 'comment'
 
def get_page(uri)
    resp = Net::HTTP.get_response(URI.parse(uri))
    resp_text = resp.body
    result = JSON.parse(resp_text)
    return result
end
    
def get_original_author(result)
    return result[0]['data']['children'][0]["data"]["author"]
end
 
def toplevel(result, list, op)    
    result[1]['data']['children'].each do |x|
        traverse_thread(x['data'], list, op)
    end
end
 
def traverse_thread(thread, list, op)
        #puts thread['body'] + " " + thread['author']
        if thread['author'] == op
            comm = Comment.new(thread['body'], thread['name'], thread['parent_id'], thread['author'])  
            list.push(comm)
        end
        unless thread['replies']['data'].nil?
            thread['replies']['data']['children'].each do |reply|
                traverse_thread(reply['data'], list, op)
        end
    end
    return list
end

def print_list(list)
    list.each {|x| puts x}
end

def get_parent(child)
    return child['parent_id']
end
        
if __FILE__ == $0
	uri = ARGV[0] ||
	'http://www.reddit.com/r/reddistructure/comments/1ccskj/test3/.json'
	#'http://www.reddit.com/r/IAmA/comments/1can9j/iama_macrophile_ama.json'
	comments = Array.new
	result = get_page(uri)
	op = get_original_author(result)
	toplevel(result, comments, op)
	print_list(comments)
end