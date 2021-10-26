class ApplicationsController < ApplicationController
  def index
  end

  def new
  end

  def create
    application = Application.new(application_params.merge(status: 'In Progress'))
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash.alert = "Must fill out all fields to continue."
    end
  end

  def show # THIS IS NOT Restful, needs to change accordingly once done with applying for pets section
    @application = Application.find(params[:id])
    @pets = ApplicationPet.match(params)

    if params[:reason].present?
      @application.reason = params[:reason]
      @application.status = "Pending"
    end

    if params[:name].nil?
      @matching_pets = []
    else
      @matching_pets = Pet.where(name: params[:name])
    end
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code)
  end
end
