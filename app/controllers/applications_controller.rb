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
    binding.pry
    if !params.values.include?("")
      application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash.alert = "Must fill out all fields to continue."
    end
  end

  def show
    @application = Application.find(params[:id])
    @pets = [] # this is temporary until I've created a PetsApplications table
  end
end
