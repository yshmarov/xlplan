class AppointmentPolicy < ApplicationPolicy
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
    @record.planned? && admin_or_manager_or_owner
    #unless self.is_planned && ends_at > Time.zone.now + 24.hours
  end

  def update?
    @record.planned? && admin_or_manager_or_owner
    #user.admin? or not post.published?
  end

  def destroy?
    @record.planned? && admin_or_manager_or_owner
    #admin_or_manager_or_owner
  end

  def admin_or_manager_or_owner
    @user.has_role?(:admin) || @user.has_role?(:manager) || @record.member_id == @user.member.id
  end

  def any_member
    @user.has_role?(:admin) || @user.has_role?(:manager) || @user.has_role?(:specialist)
  end

end
