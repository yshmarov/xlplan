class MemberPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    admin_or_manager_or_specialist
  end

  def show_money?
    admin_or_owner
  end

  def new?
    admin_or_manager
  end

  def create?
    admin_or_manager
  end

  def edit?
    admin_or_manager_or_this_member
  end

  def update?
    admin_or_manager_or_this_member
  end

  def destroy?
    admin && @record.jobs.none? && @record.user.nil? && @record.transactions.none?
  end

  def admin_or_manager_or_this_member
    @user.has_role?(:admin) || @user.has_role?(:manager) || @record.id == @user.member.id
  end

  def admin_or_owner
    @user.has_role?(:admin) || @record.id == @user.member.id
  end
end
