class ClientPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    anybody
  end

  def edit?
    anybody
  end

  def update?
    anybody
  end

  def destroy?
    admin_or_manager
  end

  def admin_or_manager
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def anybody
    @user
  end

end
