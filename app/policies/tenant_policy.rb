class TenantPolicy < ApplicationPolicy
  def show?
    admin
  end

  def edit?
    admin
  end

  def edit_plan?
    admin
  end

  def update?
    admin
  end
end
