class AdminController < ApplicationController
  def shelters
    @shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
  end
end
