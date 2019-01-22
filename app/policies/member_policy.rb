class MemberPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    anybody
  end

  def create?
    admin
  end

  def new?
    admin
  end

  def edit?
    admin_or_manager_or_owner
  end

  def update?
    admin_or_manager_or_owner
  end

  def destroy?
    admin
    @record.jobs.none? && @record.members.none? && admin
  end

  def admin
    @user.has_role?(:admin)
  end

  def admin_or_manager_or_owner
    @user.has_role?(:admin) || @user.has_role?(:manager) || @record.id == @user.member.id
  end

  def anybody
    @user
  end

end
