class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    any_member
  end

  def create?
    admin
  end

  def new?
    admin
  end

  def edit?
    admin
  end

  def update?
    admin
  end

  def destroy?
    admin
  end

  def admin
    @user.has_role?(:admin)
  end

  def any_member
    @user.has_role?(:admin) || @user.has_role?(:manager) || @user.has_role?(:specialist)
  end
end
