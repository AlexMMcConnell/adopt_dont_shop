require 'rails_helper'

RSpec.describe 'shelter_index' do
  before(:each) do
    shelter1 = Shelter.create(foster_program: true, name: 'Dumb Friends League', city: 'Denver', rank: 7)
    Shelter.create(foster_program: true, name: 'Pets for Pals', city: 'Aurora', rank: 5)
    Shelter.create(foster_program: false, name: 'Cats and Dogs', city: 'Cenntenial', rank: 6)
    application = Application.create(name: 'Bob Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "In Progress")
    pet1 = Pet.create(adoptable: true, age: 7, breed: 'Golden Retriever', name: 'Brownie', shelter_id: shelter1.id)
    Pet.create(adoptable: true, age: 7, breed: 'Husky', name: 'Snowy', shelter_id: shelter1.id)
    ApplicationPet.create(pet_id: pet1.id, application_id: application.id)
  end
  it 'shows shelters in reverse alphabetical order' do
    visit "/admin/shelters"

    expect('Pets for Pals').to appear_before('Dumb Friends League')
    expect('Dumb Friends League').to appear_before('Cats and Dogs')
  end

  it 'only shows shelters with pending applications under the corresponding section' do
    visit "/admin/shelters"
    
    expect(page).to have_content('Dumb Friends League').twice
    expect(page).to_not have_content('Pets for Pals').twice
    expect(page).to_not have_content('Cats and Dogs').twice
  end
end
