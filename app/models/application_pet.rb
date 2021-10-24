class ApplicationPet < ApplicationRecord
  def self.match(params)
    matching_pet_apps = self.where(application_id: params[:id])
    matching_pet_apps.map do |application_pet|
      Pet.where(id: application_pet.pet_id)
    end.flatten
  end
end
