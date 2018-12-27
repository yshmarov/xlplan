class TenantsController < ApplicationController
  before_action :set_tenant
  def edit
    authorize @tenant
  end

  def show
    #@tenant = Tenant.current_tenant
  end
  
  def update
    authorize @tenant
    if @tenant.update(tenant_params)
      redirect_to organization_show_path(Tenant.current_tenant), notice: 'Plan was successfully updated.'
    else
      render :edit
    end
  end

  def change
    @tenant = Tenant.find(params[:id])
    Tenant.set_current_tenant @tenant.id
    session[:tenant_id] = Tenant.current_tenant.id
    redirect_to home_index_path, notice: "Switched to organization #{@tenant.name}"
  end
  
  private
  
  def set_tenant
    @tenant = Tenant.find(Tenant.current_tenant_id)
  end
  
  def tenant_params
    params.require(:tenant).permit(:name, :plan, :industry, :default_currency, :locale)
  end
end