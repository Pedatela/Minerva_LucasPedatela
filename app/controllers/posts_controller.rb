class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :require_same_user,only: [:update,:destroy]

# GET /posts
  def index
    @posts =Post.all
    render json: @posts
  end

# POST /posts
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end
# GET /posts/1
  def show
    render json: @post
  end

# PATCH/PUT /contacts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

# DELETE /contacts/1
  def destroy
    @post.destroy
  end

private

  def set_post
      @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:title, :body, :user_id)
  end

  def require_same_user
      if current_user.id!= @post.user_id
         msg = { :message => "You can only edit or delete your own post!" }
        render :json => msg
    end
  end
end
