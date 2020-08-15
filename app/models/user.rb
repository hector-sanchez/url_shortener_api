class User < ApplicationRecord
  validates :email, uniqueness: true
  validates_format_of :email, with: /@/ # I prefer to validate the email via a confirmation message, 
                                        # hence the simple format validation
  validates :password_digest, presence: true

  has_secure_password
end
