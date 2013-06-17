class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
    params[:p] = '0' unless params.has_key?(:p)
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @comments = Image.where("id = #{params[:id]} OR parent = #{params[:id]}")
  end

  # GET /images/new
  def new
    @coo={:jdl => 'Anonymous', :parent => 'user'}
    if params.has_key?(:p)
      @coo[:parent] = params[:p]
    end
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @img = Image.new;
    name = Digest::SHA1.hexdigest(Time.now.to_s)
    @img.fname = "#{name}.png"
    @img.author = params[:author_]
    @img.parent = params[:parent_]
    @img.public = params[:public]

    File.open("#{Rails.root}/public/img/#{name}.png", 'wb') do |f|
      f.write(Base64.decode64(params[:data]))
      f.close
    end
    
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
  # PATCH/PUT /images/1.json
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
  # DELETE /images/1.json
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