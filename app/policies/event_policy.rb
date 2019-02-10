class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    any_member
  end

  def new?
    any_member
  end

  def create?
    any_member 
  end

  def edit?
    @record.planned? && admin_or_manager || @record.planned? && @user.has_role?(:owner, @record)
  end

  def update?
    @record.planned? && admin_or_manager || @record.planned? && @user.has_role?(:owner, @record)
  end

  def destroy?
    @record.planned? && admin_or_manager || @record.planned? && @user.has_role?(:owner, @record)
  end

  def admin_or_manager
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def admin
    @user.has_role?(:admin)
  end

  def any_member
    @user.has_role?(:admin) || @user.has_role?(:manager) || @user.has_role?(:specialist)
  end

end
