class ClientPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show_phone?
    admin_or_manager
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
    admin_or_manager_or_specialist
  end

  def update?
    admin_or_manager_or_specialist
  end

  def destroy?
    @record.events.none? && admin_or_manager && @record.leads.none? && @record.transactions.none?
  end
end
