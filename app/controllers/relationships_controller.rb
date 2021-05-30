class RelationshipsController < ApplicationController

  # we want to follow someone
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    redirect_to @user
  end

  # we want to unfollow someone
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    redirect_to @user
  end
end
