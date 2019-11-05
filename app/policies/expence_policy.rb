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
    admin_or_manager_or_specialist
  end

  def create?
    admin_or_manager_or_specialist
  end

  def new?
    admin_or_manager_or_specialist
  end

  def destroy?
    admin
  end
end