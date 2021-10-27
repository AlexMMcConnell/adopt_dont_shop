class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  # refactor once 100% coverage is hit
  def self.pending_applications
    self.all.map do |shelter|
      pets = shelter.pets
      @matching_applications = []
      pets.each do |pet|
        @matching_applications << ApplicationPet.where(pet_id: pet.id)
      end
      @matching_applications = @matching_applications.flatten
      if @matching_applications.present?
        shelter
      end
    end.compact
  end
end
