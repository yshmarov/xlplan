class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def edit
    authorize @user
  end
  
  def update
    authorize @user
    if @user.update(user_params)
      redirect_to @user.employee, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to employees_url, notice: 'User was successfully destroyed.'
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit({role_ids: []})
  end
end