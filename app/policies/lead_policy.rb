class LeadPolicy < ApplicationPolicy
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
    any_member
  end

  def update?
    any_member
  end

  def destroy?
    #@user.has_role?(:manager)
    admin_or_manager
  end
end