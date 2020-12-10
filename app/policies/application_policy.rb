class ApplicationPolicy
  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, "must be logged in" unless user
      @user = user
      @scope = scope
    end
  end

  def admin
    @user.has_role?(:admin)
  end

  def manager
    @user.has_role?(:manager)
  end

  def specialist
    @user.has_role?(:specialist)
  end

  def admin_or_manager
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def admin_or_manager_or_specialist
    @user.has_role?(:admin) || @user.has_role?(:manager) || @user.has_role?(:specialist)
  end

  def superadmin
    @user.has_role?(:superadmin)
  end
end
