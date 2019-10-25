class ServicePolicy < ApplicationPolicy
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
    admin_or_manager
  end

  def update?
    admin_or_manager
  end

  def destroy?
    @record.jobs.none? && admin_or_manager
  end
end
