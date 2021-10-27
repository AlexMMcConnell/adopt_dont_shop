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

  def show
    @application = Application.find(params[:id])
    @application.add_reason(params)
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :id)
  end
end
