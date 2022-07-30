class ProfileController < ApplicationController
  include ProfileHelper
  before_action :set_user

  def show
    @user = current_user
  end

  def follow
    Relationship.create_or_find_by(follower_id: current_user.id, followee_id: @user.id)
    respond_to do |format|
      format.turbo_stream do
        # john doe with a user id of 2
        # dom_id_for_follower(@user) -> user_2
        render turbo_stream: [
          turbo_stream.replace(dom_id_for_follower(@user),
                               partial: 'profile/follow_button',
                               locals: { user: @user }),
          turbo_stream.update("#{@user.id}-follower-count",
                              partial: 'profile/follower_count',
                              locals: { user: @user })
        ]
      end
    end
  end

  def unfollow
    current_user.followed_users.where(follower_id: current_user.id, followee_id: @user.id).destroy_all
    respond_to do |format|
      format.turbo_stream do
        # john doe with a user id of 2
        # dom_id_for_follower(@user) -> user_2
        render turbo_stream: [
          turbo_stream.replace(dom_id_for_follower(@user),
                               partial: 'profile/follow_button',
                               locals: { user: @user }),
          turbo_stream.update("#{@user.id}-follower-count",
                              partial: 'profile/follower_count',
                              locals: { user: @user })
        ]
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end