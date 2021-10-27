require 'rails_helper'

RSpec.describe 'admin_application' do
  before(:each) do
    shelter1 = Shelter.create!(foster_program: true, name: 'Dumb Friends League', city: 'Denver', rank: 7)
    @application = Application.create!(name: 'Bob Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "Pending")
    @application2 = Application.create!(name: 'Jane Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "Pending")
    @pet = Pet.create!(adoptable: true, age: 7, breed: 'Golden Retriever', name: 'Brownie', shelter_id: shelter1.id)
    @pet2 = Pet.create!(adoptable: true, age: 7, breed: 'Husky', name: 'Snow', shelter_id: shelter1.id)
    ApplicationPet.create!(application: @application, pet: @pet)
    ApplicationPet.create!(application: @application, pet: @pet2)
    ApplicationPet.create!(application: @application2, pet: @pet)
  end
  describe 'button to approve pet application' do
    it 'approves a pet' do
      visit "/admin/applications/#{@application.id}"

      expect(current_path).to eq("/admin/applications/#{@application.id}")

      click_button id: "#{@pet[:name]} accept"

      expect(current_path).to eq("/admin/applications/#{@application.id}")
      expect(page).to have_content("Pet accepted for this Application")
      expect(page).to have_button("Deny")
    end
  end
  describe 'button to reject pet application' do
    it 'rejects a pet' do
      visit "/admin/applications/#{@application.id}"

      expect(current_path).to eq("/admin/applications/#{@application.id}")

      click_button id: "#{@pet.name} deny"
      click_button id: "#{@pet2.name} accept"

      expect(current_path).to eq("/admin/applications/#{@application.id}")
      expect(page).to have_content("Pet denied for this application.")
      expect(page).to_not have_button("Accept")
    end
  end
  it "buttons don't affect other applications" do
    visit "/admin/applications/#{@application.id}"

    click_button id: "#{@pet.name} accept"

    visit "/admin/applications/#{@application2.id}"

    expect(page).to have_button("Accept")
    expect(page).to have_button("Deny")
  end
  it "if all pets are approved, status is accepted" do
    visit "/admin/applications/#{@application.id}"

    click_button id: "#{@pet.name} accept"
    click_button id: "#{@pet2.name} accept"
    
    expect(page).to have_content("Approved")
  end
  it "if all pets are accepted/rejected and one is rejected, status is rejected" do
    visit "/admin/applications/#{@application.id}"

    click_button id: "#{@pet.name} deny"
    click_button id: "#{@pet2.name} accept"

    expect(page).to have_content("Rejected")
  end
  it "if application is approved for a pet, that pet isn't adoptable" do
    visit "/admin/applications/#{@application.id}"
    click_button id: "#{@pet.name} accept"
    click_button id: "#{@pet2.name} accept"
    visit "/pets/#{@pet.id}"

    expect(page).to have_content(false)
  end
  it 'shows that pet is approved for adoption if pet is on approved application' do
    visit "/admin/applications/#{@application.id}"
    click_button id: "#{@pet.name} accept"
    click_button id: "#{@pet2.name} accept"
    visit "/admin/applications/#{@application2.id}"

    expect(page).to have_content("Pet has been approved for adoption by another applicant.")
    expect(page).to_not have_button("Accept")
  end
end
