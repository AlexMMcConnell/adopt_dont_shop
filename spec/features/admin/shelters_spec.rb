require 'rails_helper'

RSpec.describe 'shelter_index' do
  before(:each) do
    Shelter.create(foster_program: true, name: 'Dumb Friends League', city: 'Denver', rank: 7)
    Shelter.create(foster_program: true, name: 'Pets for Pals', city: 'Aurora', rank: 5)
    Shelter.create(foster_program: false, name: 'Cats and Dogs', city: 'Cenntenial', rank: 6)
  end
  it 'shows shelters in reverse alphabetical order' do
    visit "/admin/shelters"

    expect('Pets for Pals').to appear_before('Dumb Friends League')
    expect('Dumb Friends League').to appear_before('Cats and Dogs')
  end
end
