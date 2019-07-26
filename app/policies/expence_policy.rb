class ExpencePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    #if @user.has_role?(:admin)
    #
    #elsif @user.has_role?(:manager)
    #  
    #elsif @user.has_role?(:specialist)
    #  
    #end
    any_member
  end

  def create?
    any_member
  end

  def new?
    any_member
  end

  def edit?
    superadmin
  end

  def update?
    superadmin
  end

  def destroy?
    admin
  end
end