class Application < ApplicationRecord
  validates_presence_of :name, :street_address, :city, :state, :zip_code
  has_many :application_pets
  has_many :pets, through: :application_pets

  def check_if_completed
    app_pet = ApplicationPet.where(application_id: self.id).group(:accepted).count
    if app_pet[false] == nil && app_pet[nil] == nil
      self.status = "Approved"
      self.pets.update_all(adoptable: false)
    elsif app_pet[nil] == nil
      self.status = "Rejected"
    else
    end
    self
  end
end
