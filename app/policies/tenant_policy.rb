class TenantPolicy < ApplicationPolicy
  def show?
    admin
  end

  def edit?
    admin
  end

  def update?
    admin
  end
end
