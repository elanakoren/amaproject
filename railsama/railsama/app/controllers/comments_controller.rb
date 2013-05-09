require 'rubygems'
require 'json'
require 'net/http'
require 'comment'

class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  def start_download
      @id = params[:id]
      @url = "http://www.reddit.com/r/IAMA/comments/" + @id + "/.json"
      @resp = Net::HTTP.get_response(URI.parse(@url))
      @resp_text = @resp.body
      @result = JSON.parse(@resp_text)
      @op = @result[0]['data']['children'][0]['data']['author']
      @title = @result[0]['data']['children'][0]['data']['title']
      @list = Array.new
      @masterlist = Array.new 
      toplevel(@result, @list, @op)
      find_parent(@list, @result, @masterlist) 
    end

    def toplevel(result, list, op)    
        result[1]['data']['children'].each do |x|
        	traverse_thread(x['data'], @list, op)
    	end
   end

   def traverse_thread(thread, list, op)
       if thread['author'] == op
           h = {:body => thread['body'], :unique_id => thread['name'], :parent_id => thread['parent_id'], :author => thread['author']}
            	comm = Comment.new(h)  
            	@list.push(comm)
        end
        unless thread['replies'].nil? or thread['replies']['data'].nil?
            thread['replies']['data']['children'].each do |reply|
                traverse_thread(reply['data'], @list, op)
            end
        end
    end

    def find_parent(list, result, masterlist)
        list.each do |comment|
            top_parent(comment, result, masterlist)
        end
    end

    def top_parent(comment, result, masterlist)
        result[1]['data']['children'].each do |x|
            get_parent(x['data'], comment, masterlist)
        end
    end

    def get_parent(thread, comment, masterlist)
        if thread['name'] == comment.parent_id
            parent = Comment.new
            parent.body = thread['body']
            parent.unique_id = thread['name']
            parent.parent_id = thread['parent_id']
            parent.author = thread['author']
            sublist = [parent, comment]
            masterlist.push(sublist)
        end
        unless thread['replies'].nil? or thread['replies']['data'].nil?
            thread['replies']['data']['children'].each do |reply|
                get_parent(reply['data'], comment, masterlist)
            end
        end
    end	

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
