class Admin < ActiveRecord::Base
  has_secure_password
  has_one :portfolio, dependent: :destroy
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, confirmation: true, length: { minimum: 4 }, if: :password
  validate :admin_nonexistance, :on => :create

  def admin_nonexistance
  	if Admin.first != nil
      errors.add(:base, "Admin account has already been created.")
    end
  end
end
