class CashAccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
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
    admin
  end
end
