require "#{Rails.root}/lib/tasks/imgur.rb"

class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => :create
  
  # GET / /images
  def index
    @images = Image.all
    params[:p] = '0' unless params.has_key?(:p)
  end

  # GET /images/1
  def show
    @comments = Image.where("id = #{params[:id]} OR parent = '#{params[:id]}'")
  end

  # GET /images/new
  def new
    @coo={:jdl => 'Anonymous', :parent => 'user'}
    if params.has_key?(:p)
      @coo[:parent] = params[:p]
    end
    @image = Image.new
    
    Rails.logger.info '-> debug test'
  end

  # POST /images
  def create
    Rails.logger.info '-> create'
    @imgur = Imgur::API.new '2c7a02d71633c71'
    Rails.logger.info '-> imgur create'
    @img = Image.new
    Rails.logger.info '-> image new'
    #name = "#{Digest::SHA1.hexdigest(Time.now.to_s)}_#{Process.pid}"
    #@img.fname = "#{name}.png"
    @img.author = params[:author_]
    @img.parent = params[:parent_]
    @img.public = params[:public]
    
    #File.open("#{Rails.root}/tmp/#{name}", 'wb') do |f|
      #f.write(Base64.decode64(params[:data]))
    #end
    Rails.logger.info '-> start sending'
    #@img.fname = (@imgur.upload_file "#{Rails.root}/tmp/#{name}")["link"]
    @img.fname = (@imgur.upload_from_bytes params[:data])["link"]
    Rails.logger.info '-> sent'
    respond_to do |format|
      if @img.save
        format.html { redirect_to "/", notice: 'Image was successfully created.' }
        format.json { render action: 'show', status: :created, location: "/" }
      else
        format.html { render action: 'new' }
        format.json { render json: @img.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params[:image]
    end
end
