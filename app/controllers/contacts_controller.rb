class ContactsController < ApplicationController
  def identify
    email = params[:email]
    phone_number = params[:phoneNumber]

    if email.blank? && phone_number.blank?
      render json: { error: 'Email or phone number must be provided' }, status: :unprocessable_entity
      return
    end

    primary_contact = find_primary_contact(email, phone_number)

    if primary_contact
      consolidate_contact(primary_contact, email, phone_number)
    else
      primary_contact = create_primary_contact(email, phone_number)
    end

    render json: build_response(primary_contact)
  end

  private

  def find_primary_contact(email, phone_number)
    contacts = Contact.active.where(email: email).or(Contact.active.where(phone_number: phone_number))

    primary_contacts = contacts.where(link_precedence: 'primary')
    return primary_contacts.order(:created_at).first if primary_contacts.exists?

    contacts.order(:created_at).first
  end

  def consolidate_contact(primary_contact, email, phone_number)
    contacts_to_link = Contact.active.where(email: email).or(Contact.active.where(phone_number: phone_number)).where.not(id: primary_contact.id)

    contacts_to_link.each do |contact|
      if contact.link_precedence == 'primary'
        primary_contact.update(linked_id: contact.id, link_precedence: 'secondary')
        primary_contact = contact
      else
        contact.update(linked_id: primary_contact.id, link_precedence: 'secondary')
      end
    end

    unless primary_contact.email == email && primary_contact.phone_number == phone_number
      Contact.create(email: email, phone_number: phone_number, linked_id: primary_contact.id, link_precedence: 'secondary')
    end
  end

  def create_primary_contact(email, phone_number)
    Contact.create(email: email, phone_number: phone_number, link_precedence: 'primary')
  end

  def build_response(primary_contact)
    secondary_contacts = Contact.active.where(linked_id: primary_contact.id)
    {
      contact: {
        primaryContactId: primary_contact.id,
        emails: [primary_contact.email, *secondary_contacts.pluck(:email)].compact,
        phoneNumbers: [primary_contact.phone_number, *secondary_contacts.pluck(:phone_number)].compact,
        secondaryContactIds: secondary_contacts.pluck(:id)
      }
    }
  end
end
