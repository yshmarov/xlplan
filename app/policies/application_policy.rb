class ApplicationPolicy
  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user   = user
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

  def admin_or_manager
    @user.has_role?(:admin) || @user.has_role?(:manager)
  end

  def admin
    @user.has_role?(:admin)
  end

  def any_member
    @user.has_role?(:admin) || @user.has_role?(:manager) || @user.has_role?(:specialist)
  end

  def superadmin
    @user.has_role?(:superadmin)
  end

 #  attr_reader :user, :record
 #
 #  def initialize(user, record)
 #    @user = user
 #    @record = record
 #  end
 #
 #  def index?
 #    false
 #  end
 #
 #  def show?
 #    false
 #  end
 #
 #  def create?
 #    false
 #  end
 #
 #  def new?
 #    create?
 #  end
 #
 #  def update?
 #    false
 #  end
 #
 #  def edit?
 #    update?
 #  end
 #
 #  def destroy?
 #    false
 #  end
 #
 #  class Scope
 #    attr_reader :user, :scope
 #
 #    def initialize(user, scope)
 #      @user = user
 #      @scope = scope
 #    end
 #
 #    def resolve
 #      scope.all
 #    end
 #  end
end
