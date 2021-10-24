class ApplicationPetsController < ApplicationController
  def create
    ApplicationPet.create(
      pet_id: params[:pet_id],
      application_id: params[:app_id]
    )
    redirect_to "/applications/#{params[:app_id]}"
  end
end
