class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    admin_or_manager_or_specialist
  end

  def create?
    admin_or_manager_or_specialist
  end

  def new?
    admin_or_manager_or_specialist
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
