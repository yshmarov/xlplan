class EmployeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    anybody
  end

  def edit?
    admin_or_manager_or_owner
  end

  def update?
    admin_or_manager_or_owner
  end


  def destroy?
    admin_or_manager_or_owner
  end

  def admin_or_manager_or_owner
    @user.has_role?(:admin) || @user.has_role?(:manager) || @record.id == @user.employee.id
  end

  def anybody
    @user
  end

end
