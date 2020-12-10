class ContactsController < ApplicationController
  include Pagy::Backend

  def import
    # IMPORT CONTACTS FROM GOOGLE
    @contacts = request.env["omnicontacts.contacts"]

    @contacts.each do |contact|
      contact1 = Contact.find_or_create_by(import_id: contact[:id])
      contact1.email = contact[:email]
      contact1.import_id = contact[:id]
      contact1.name = contact[:name]
      contact1.first_name = contact[:first_name]
      contact1.last_name = contact[:last_name]
      # if contact[:last_name].present?
      #  contact1.last_name = contact[:last_name]
      # else
      #  contact1.last_name = contact[:family_name]
      # end
      contact1.address_1 = contact[:address_1]
      contact1.address_2 = contact[:address_2]
      contact1.city = contact[:city]
      contact1.region = contact[:region]
      contact1.postcode = contact[:postcode]
      contact1.country = contact[:country]
      contact1.phone_number = contact[:phone_number]
      contact1.birthday = contact[:birthday]
      contact1.gender = contact[:gender]
      contact1.relation = contact[:relation]
      contact1.save
    end
    redirect_to contacts_path, notice: "Contacts successfully imported"
    # respond_to do |format|
    #  format.html
    # end
  end

  def index
    # SHOW ALL CONTACTS
    @pagy, @contacts = pagy(Contact.order("created_at DESC"))
    # @clients = Client.all #for selectize
    # render 'index'
  end

  def create_client_from_contact
    # SELECT A CONTACT AND CONVERT HIM INTO A CLIENT
    @contact = Contact.find(params[:id])
    @client = Client.new
    @client.first_name = if @contact.first_name.present?
      @contact.first_name
    else
      "?"
    end
    @client.last_name = if @contact.last_name.present?
      @contact.last_name
    else
      "?"
    end
    @client.email = @contact.email
    @client.phone_number = @contact.phone_number
    @client.lead_source = "import"
    @client.save
    @contact.update_attribute(:client_id, @client.id)

    if @client.save
      redirect_to contacts_path, notice: "Client was successfully created."
    else
      redirect_to contacts_path, alert: "Error."
    end
  end

  def add_all
    # CONVERT ALL CONTACTS TO CLIENTS
    Contact.where(client_id: nil).limit(5).each do |contact|
      client = Client.new
      client.first_name = if contact.first_name.present?
        contact.first_name
      else
        "?"
      end
      client.last_name = if contact.last_name.present?
        contact.last_name
      else
        "?"
      end
      # client.address_1 = contact.address_1
      # client.address_2 = contact.address_2
      # client.city = contact.city
      # client.region = contact.region
      # client.postcode = contact.postcode
      # client.country = contact.country
      client.email = contact.email
      client.phone_number = contact.phone_number
      client.lead_source = "import"
      # client.birthday = contact.birthday
      # client.gender = contact.gender
      # client.relation = contact.relation
      client.save
      contact.update_attribute(:client_id, client.id)
    end
    redirect_to contacts_path, notice: "All clients successfully added"
  end

  def fill_missing_client_data # DOES NOT WORK!!!!
    if params.has_key?(:select)
      client = params[:select][:client].to_s
    end
    @contact = Contact.find(params[:id])
    # select client
    if client.phone_number.nil? && @contact.phone_number.present?
      client.update_attribute(:phone_number, @contact.phone_number)
    end
    if client.email.nil? && @contact.email.present?
      client.update_attribute(:email, @contact.email)
    end
    @contact.update_attribute(:client_id, client.id)
    redirect_to contacts_path, notice: "Missing client data successfully added"
  end
end
