class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    admin_or_manager
  end

  def create?
    admin_or_manager
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
end
