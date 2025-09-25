class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.new(comment_params)
    comment.user = current_user
    if comment.save
      flash[:notice] = "コメントの投稿に成功しました"
      redirect_to request.referer
    else
      flash[:notice] = "コメントを投稿できませんでした"
      redirect_to request.referer
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    if comment.present?
      flash[:notice] = "コメントを削除しました"
      comment.destroy
    else
      flash[:alert] = "コメントが見つかりませんでした"
    end
    redirect_to request.referer
  end 

private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
