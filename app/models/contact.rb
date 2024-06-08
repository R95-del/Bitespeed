class Contact < ApplicationRecord

  enum link_precedence: { primary: 'primary', secondary: 'secondary' }

  validates :link_precedence, inclusion: { in: link_precedences.keys }

  scope :active, -> { where(deleted_at: nil) }
end
