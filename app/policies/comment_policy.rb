class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    admin_or_owner
  end

  def admin_or_owner
    @record.employee_id == @user.employee.id || @user.has_role?(:admin)
  end

end
