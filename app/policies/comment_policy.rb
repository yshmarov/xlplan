class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    admin_or_manager || owner
  end

  def owner
    @record.user_id == @user.id || @user.has_role?(:admin)
  end
end