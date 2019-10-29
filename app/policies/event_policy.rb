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
    admin || manager || @user.has_role?(:owner, @record)
  end

  def update?
    admin || manager || @user.has_role?(:owner, @record)
  end

  def destroy?
    #@record.planned? && admin_or_manager || @record.planned? && @user.has_role?(:owner, @record)
    admin || manager || @record.planned? && @user.has_role?(:owner, @record)
  end
end