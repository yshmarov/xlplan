class ContactsController < ApplicationController
  def index
    @contacts = request.env['omnicontacts.contacts']

    @contacts.each do |contact|
      contact1 = Contact.new
      contact1.email = contact[:email]
      contact1.import_id = contact[:id]
      contact1.name = contact[:name]
      contact1.first_name = contact[:first_name]
      contact1.last_name = contact[:last_name]
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
    redirect_to contacts_list_path, notice: 'Contacts successfully imported'
      #respond_to do |format|
      #  format.html
      #end
  end

  #def create
  #  @contact = Contact.new(contact_params)
  #  @contact.save
  #end

	def create_client_from_contact
	  @contact = Contact.find(params[:id])
	  @client = Client.new
  	  if @contact.first_name.present?
    	  @client.first_name = @contact.first_name
  	  else
    	  @client.first_name = @contact.name
  	  end
  	  if @contact.last_name.present?
    	  @client.last_name = @contact.last_name
  	  else
    	  @client.last_name = @contact.name
  	  end
  	  @client.email = @contact.email
  	  @client.phone_number = @contact.phone_number
  	  @client.save
		#@event.update_attribute(:status, 'planned')
		#@contact.destroy
		redirect_to contacts_list_path, notice: "Client created"
	end


  def list
    @contacts = Contact.all
    render 'index'
  end

  #def contact_callback
  #  @contacts = request.env["omnicontacts.contacts"]
  #  @user = request.env["omnicontacts.user"]
  #  puts "List of contacts of #{user[:name]} obtained from #params[:importer]}:"
  #  @contacts.each do|contact|
  #    puts "Contact found: name => #{contact[:name]}, email => #{contact[:email]}"
  #  end
  #end

  #private
  #  def contact_params
  #    params.require(:contact).permit(:email,
  #                                    :id,
  #                                    :name,
  #                                    :first_name,
  #                                    :last_name,
  #                                    :address_1,
  #                                    :address_2,
  #                                    :city,
  #                                    :region,
  #                                    :postcode,
  #                                    :country,
  #                                    :phone_number,
  #                                    :birthday,
  #                                    :gender,
  #                                    :relation)
  #  end

end
