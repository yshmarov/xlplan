class ServiceCategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    admin
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
    admin
  end

  def admin
    @user.has_role?(:admin)
  end

  def admin_or_manager
    #@user.has_any_role? :admin, :manager
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def anybody
    @user
  end

end
