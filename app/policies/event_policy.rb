class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    admin_or_manager_or_specialist
  end

  def new?
    admin_or_manager_or_specialist
  end

  def create?
    admin_or_manager_or_specialist 
  end

  def edit?
    admin || manager || @record.planned? && specialist
    #manager
    #admin || @record.event.planned? && manager || @record.event.planned? && @user.has_role?(:owner, @record.event)
    #admin || @record.event.planned? && manager || @record.event.planned? && @record.member_id == @user.member.id
    #@record.event.planned? && admin_or_manager_or_owner
    #admin_or_manager_or_owner
    #admin || manager ||  @record.member_id == @user.member.id
  end

  def update?
    #manager
    admin || manager || @record.planned? && specialist
  end

  def destroy?
    #@record.planned? && admin_or_manager || @record.planned? && @user.has_role?(:owner, @record)
    admin || manager || @record.planned? && specialist
  end
end