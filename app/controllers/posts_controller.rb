class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy toggle_like share]
  before_action :set_attachable_post, only: :new
  before_action :authenticate_user!

  # GET /posts or /posts.json
  def index
    # return only posts of all friends
    @post = Post.new
    @posts = Post.feed current_user
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @attachable_post ? @post.attachments.build(attachable: @attachable_post) : nil
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)
    binding.pry

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_like
    @likes_count = @post.likes_count

    if current_user.liked?(@post)
      current_user.unlike(@post)
    else
      current_user.like(@post)
      @liked = true
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def share
    current_user.share(@post)

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def set_attachable_post
    @attachable_post = Post.where(id: params[:attachable_post]).take
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:content, attachments_attributes: [:post_id, :attachable_id, :attachable_type])
  end
end
