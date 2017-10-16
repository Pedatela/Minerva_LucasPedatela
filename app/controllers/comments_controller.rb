class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:index,:create,:show,:update,:destroy]
  before_action :set_comment, only: [:show,:update, :destroy]
  before_action :require_same_user,only: [:update,:destroy]

  def index
    @comment = @post.comments.all
    render json: @comment
  end




  def create
     @comment = Comment.new(post_id: params[:post_id])
     @comment = @post.comments.create(comment_params)
     @comment.user_id = current_user.id
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def show
    @comment = @post.comments.find(params[:id])
    render json: @comment
  end

  def update
      @comment = @post.comments.update(comment_params)
      render json: @comment
  end

  def destroy
    @comment.destroy
  end

private
  def set_post
    @post=Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body,:user_id)
  end
      def require_same_user
            if current_user.id!= @comment.user_id
               msg = { :message => "You can only edit or delete your own comments!" }
               render :json => msg
            end
      end
end
