class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    admin
  end

  def new?
    admin
  end

  def create?
    admin
  end

  def update?
    admin
  end

  def destroy?
    admin
  end
end
