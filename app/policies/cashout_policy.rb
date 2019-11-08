class CashoutPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    admin
  end

  def new?
    admin
  end

  def destroy?
    admin
  end
end