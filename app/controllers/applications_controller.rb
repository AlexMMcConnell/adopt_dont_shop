class ApplicationsController < ApplicationController
  def index
  end

  def new
  end

  def create
    application = Application.new(
      name: params[:name],
      street_address: params[:street_address],
      city: params[:city],
      state: params[:state],
      zip_code: params[:zip_code],
      status: 'In Progress'
    )
    if !params.values.include?("")
      application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash.alert = "Must fill out all fields to continue."
    end
  end

  def show # THIS IS NOT Restful, needs to change accordingly once done with applying for pets section
    @application = Application.find(params[:id])
    @pets = ApplicationPet.match(params)

    if params[:name].nil?
      @matching_pets = []
    else
      @matching_pets = Pet.where(name: params[:name])
    end
  end
end
