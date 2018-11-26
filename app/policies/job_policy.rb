class JobPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  #attr_reader :user, :post

  #def initialize(user, post)
  #  @user = user
  #  @post = post
  #end

  def edit?
    admin_or_manager_or_owner
  end

  def update?
    admin_or_manager_or_owner
    #user.admin? or not record.published?
    #user.admin? or not post.published?
  end


  def destroy?
    admin_or_manager_or_owner
  end

  def admin_or_manager_or_owner
    @user.has_role?(:admin) || @user.has_role?(:manager) || @record.employee_id == @user.employee.id
  end

end
