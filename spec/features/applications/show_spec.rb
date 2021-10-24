require 'rails_helper'

RSpec.describe 'application_show' do
  it 'shows all information about an application' do
    application = Application.create(name: 'Bob Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "In Progress")
    visit "/applications/#{application.id}"
    expect(page).to have_content(application.name)
    expect(page).to have_content(application.street_address)
    expect(page).to have_content(application.city)
    expect(page).to have_content(application.state)
    expect(page).to have_content(application.zip_code)
  end

  it 'can find pets based on name' do
    shelter1 = Shelter.create( foster_program: true, name: 'Dumb Friends League', city: 'Denver', rank: 3)
    application = Application.create(name: 'Bob Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "In Progress")
    Pet.create(adoptable: true, age: 7, breed: 'Golden Retriever', name: 'Brownie', shelter_id: shelter1.id)
    Pet.create(adoptable: true, age: 7, breed: 'Husky', name: 'Snowy', shelter_id: shelter1.id)
    visit "/applications/#{application.id}"

    page.fill_in('name', with: 'Brownie')
    click_button("Search")

    expect(page).to have_content('Brownie')
    expect(page).to_not have_content('Snowy')
  end

  it 'can add pets to a group' do
    shelter1 = Shelter.create( foster_program: true, name: 'Dumb Friends League', city: 'Denver', rank: 3)
    application = Application.create(name: 'Bob Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "In Progress")
    Pet.create(adoptable: true, age: 7, breed: 'Golden Retriever', name: 'Brownie', shelter_id: shelter1.id)
    Pet.create(adoptable: true, age: 7, breed: 'Husky', name: 'Snowy', shelter_id: shelter1.id)
    visit "/applications/#{application.id}"

    page.fill_in('name', with: 'Brownie')
    click_button("Search")

    click_button("Adopt this Pet")

    expect(page).to have_content('Brownie')
  end
  describe 'submit button' do
    before(:each) do
      @shelter1 = Shelter.create( foster_program: true, name: 'Dumb Friends League', city: 'Denver', rank: 3)
      @application = Application.create(name: 'Bob Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "In Progress")
      Pet.create(adoptable: true, age: 7, breed: 'Golden Retriever', name: 'Brownie', shelter_id: @shelter1.id)
      Pet.create(adoptable: true, age: 7, breed: 'Husky', name: 'Snowy', shelter_id: @shelter1.id)
      visit "/applications/#{@application.id}"
    end

    it 'displays and works if application has pets' do
      page.fill_in('name', with: 'Brownie')
      click_button("Search")
      click_button("Adopt this Pet")
      expect(page).to have_button('Submit form')
      page.fill_in('reason', with: 'I made this form')
      click_button('Submit form')

      expect(page).to have_content("Pending")
      expect(page).to have_content('Brownie')
      expect(page).to have_content('I made this form')
      expect(page).to_not have_button('Submit form')
    end

    it "doesn't display if application doesn't have pets" do
      expect(page).to_not have_button('Submit form')
    end
  end
end
