class JobPolicy < ApplicationPolicy
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
    admin || @record.event.planned? && manager || @record.event.planned? && @user.has_role?(:owner, @record.event)
    #admin || @record.event.planned? && manager || @record.event.planned? && @record.member_id == @user.member.id
    #@record.event.planned? && admin_or_manager_or_owner
    #admin_or_manager_or_owner
  end

  def update?
    admin || @record.event.planned? && manager || @record.event.planned? && @user.has_role?(:owner, @record.event)
    #admin || @record.event.planned? && manager || @record.event.planned? && @record.member_id == @user.member.id
    #@record.event.planned? && admin_or_manager_or_owner
    #admin_or_manager_or_owner
    #@user.has_role?(:owner, @record)
  end

  def destroy?
    admin || @record.event.planned? && manager || @record.event.planned? && @user.has_role?(:owner, @record.event)
    #admin || @record.event.planned? && admin_or_manager_or_owner
    #admin_or_manager_or_owner
  end

  def admin_or_manager_or_owner
    @user.has_role?(:admin) || @user.has_role?(:manager) || @record.member_id == @user.member.id
  end
end
