class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show_money?
    admin_or_manager
  end

  def show?
    any_member
  end

  def create?
    admin_or_manager
  end

  def new?
    admin_or_manager
  end

  def edit?
    admin_or_manager
  end

  def update?
    admin_or_manager
  end

  def destroy?
    @record.events.none? && @record.members.none? && admin
  end
end
