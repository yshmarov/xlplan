class ClientPolicy < ApplicationPolicy
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
    any_employee
  end

  def update?
    any_employee
  end

  def destroy?
    admin_or_manager
  end

  def admin_or_manager
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def any_employee
    @user.has_role?(:admin) || @user.has_role?(:manager) || @user.has_role?(:specialist)
  end

end
