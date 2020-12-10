class CommentsController < ApplicationController
  before_action :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    Comment.public_activity_off
    @comment = @commentable.comments.new comment_params
    @comment.user_id = current_user.id
    if @comment.save
      Comment.public_activity_on
      @comment.create_activity :create, parameters: {content: @comment.content}
      redirect_to @commentable, notice: "Comment created."
    else
      redirect_to @commentable, alert: "Comment can't be empty."
      # render :new
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    # @comment.destroy
    if @comment.destroy
      redirect_to @commentable, notice: "Comment deleted."
    end
  end

  private

  def load_commentable
    resource, id = request.path.split("/")[1, 2]
    @commentable = resource.singularize.classify.constantize.friendly.find(id)
  end

  def comment_params
    params.require(:comment).permit(:content)
    # params.require(:comment).permit(:content)
  end
end
