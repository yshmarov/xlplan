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
    @record.planned? && admin_or_manager
    #unless self.is_planned && ends_at > Time.zone.now + 24.hours
  end

  def update?
    @record.planned? && admin_or_manager
    #user.admin? or not post.published?
  end

  def destroy?
    #admin
    #@record.planned? && admin
    @record.planned? && admin_or_manager
    #admin_or_manager_or_owner
  end

  def admin_or_manager
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def admin
    @user.has_role?(:admin)
  end

  def admin_or_manager_or_owner
    #@user.has_role?(:admin) || @user.has_role?(:manager) || @record.includes(:jobs).where(jobs: {member_id: @user.member.id})
    #@user.has_role?(:admin) || @user.has_role?(:manager) || @record.member_id == @user.member.id
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def any_member
    @user.has_role?(:admin) || @user.has_role?(:manager) || @user.has_role?(:specialist)
  end

end
