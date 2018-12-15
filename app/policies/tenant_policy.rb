class TenantPolicy < ApplicationPolicy
  def edit?
    admin
  end

  def update?
    admin
  end

  def admin
    @user.has_role?(:admin)
  end

end
