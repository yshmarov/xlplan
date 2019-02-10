class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    any_member
  end

  def create?
    admin
  end

  def new?
    admin
  end

  def edit?
    admin
  end

  def update?
    admin
  end

  def destroy?
    @record.events.none? && @record.members.none? && admin
  end
end
