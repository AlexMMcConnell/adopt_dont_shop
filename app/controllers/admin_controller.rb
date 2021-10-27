class AdminController < ApplicationController
  def shelters
    @shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
    @pending_shelters = Shelter.pending_applications
  end

  def applications
    @application = Application.find(params[:id])
    @pets = @application.pets
    @application.check_if_completed
  end

  def submit
    if params[:q] == 'accept'
      app_pet = ApplicationPet.find_by(pet_id: params[:pet_id].to_i, application_id: params[:app_id].to_i)
      app_pet.update(accepted: true)
    elsif params[:q] == 'deny'
      app_pet = ApplicationPet.find_by(pet_id: params[:pet_id].to_i, application_id: params[:app_id].to_i)
      app_pet.update(accepted: false)
    else
    end
    redirect_to "/admin/applications/#{params[:app_id]}?q=#{params[:pet_id]}"
  end
end
