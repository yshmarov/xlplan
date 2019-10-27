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
    @record.events.none? && admin_or_manager
  end
end
