class ContactsController < ApplicationController
  def index
    @contacts = request.env['omnicontacts.contacts']

    @contacts.each do |contact|
      contact1 = Client.new
      if contact[:first_name].present?
        contact1.first_name = contact[:first_name]
      else
        contact1.first_name = contact[:name]
      end
      if contact[:last_name].present?
        contact1.last_name = contact[:last_name]
      else
        contact1.last_name = contact[:name]
      end
      contact1.phone_number = contact[:phone_number]
      contact1.email = contact[:email]
      #contact1.date_of_birth = contact[:birthday]
      contact1.save(:validate => false)
    end
      respond_to do |format|
        format.html
      end
  end

  #def contact_callback
  #  @contacts = request.env["omnicontacts.contacts"]
  #  @user = request.env["omnicontacts.user"]
  #  puts "List of contacts of #{user[:name]} obtained from #params[:importer]}:"
  #  @contacts.each do|contact|
  #    puts "Contact found: name => #{contact[:name]}, email => #{contact[:email]}"
  #  end
  #end

end
