class InboundPaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    any_member
  end

  def create?
    any_member
  end

  def new?
    any_member
  end

  def edit?
    any_member
  end

  def update?
    any_member
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
