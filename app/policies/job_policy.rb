class JobPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    any_employee
  end

  def new?
    any_employee
  end

  def create?
    any_employee 
  end

  def edit?
    admin_or_manager_or_owner
    #unless self.is_planned && ends_at > Time.zone.now + 24.hours
    #  admin_or_manager_or_owner
    #else
    #  admin
    #end
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

  def any_employee
    @user.has_role?(:admin) || @user.has_role?(:manager) || @user.has_role?(:specialist)
  end

end
