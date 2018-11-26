class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    admin_or_manager
  end

  def create?
    admin_or_manager
  end

  def new?
    admin_or_manager
  end

  def edit?
    admin_or_manager
  end

  def update?
    admin_or_manager
  end

  def destroy?
    admin_or_manager
  end

  def admin_or_manager
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def anybody
    @user
  end

end
