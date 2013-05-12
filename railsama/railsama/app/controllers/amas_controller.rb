class AmasController < ApplicationController
  # GET /amas
  # GET /amas.json
  def index
    @amas = Ama.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @amas }
    end
  end

  # GET /amas/1
  # GET /amas/1.json
  def show
    @ama = Ama.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ama }
    end
  end

  # GET /amas/new
  # GET /amas/new.json
  def new
    @ama = Ama.new
 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ama }
    end
  end

  # GET /amas/1/edit
  def edit
    @ama = Ama.find(params[:id])
  end

  # POST /amas
  # POST /amas.json
  def create
    @ama = Ama.find_or_create_by_url(params[:ama][:url])

    respond_to do |format|
      if @ama.save and @ama.download
        format.html { redirect_to @ama, notice: 'Ama was successfully created.' }
        format.json { render json: @ama, status: :created, location: @ama }
      else
        format.html { render action: "new" }
        format.json { render json: @ama.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /amas/1
  # PUT /amas/1.json
  def update
    @ama = Ama.find(params[:id])

    respond_to do |format|
      if @ama.update_attributes(params[:ama])
        format.html { redirect_to @ama, notice: 'Ama was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ama.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /amas/1
  # DELETE /amas/1.json
  def destroy
    @ama = Ama.find(params[:id])
    @ama.destroy

    respond_to do |format|
      format.html { redirect_to amas_url }
      format.json { head :no_content }
    end
  end
end
