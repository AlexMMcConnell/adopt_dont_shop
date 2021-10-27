class Application < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true, numericality: true
  has_many :application_pets
  has_many :pets, through: :application_pets

  def check_if_completed
    app_pet = self.application_pets.group(:accepted).count
    if (app_pet[false] == nil) && (app_pet[nil] == nil)
      self.status = "Approved"
      self.pets.update_all(adoptable: false)
    elsif app_pet[nil] == nil
      self.status = "Rejected"
    else
    end
    self
  end

  def add_reason(params)
    if params[:reason].present?
      self.reason = params[:reason]
      self.status = "Pending"
    end
  end

  def show_pets(params)
    if params[:name].nil?
      []
    else
      Pet.where(name: params[:name])
    end
  end
end
