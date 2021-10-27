require 'rails_helper'

RSpec.describe ApplicationPet do
  describe 'relationships' do
    it { should belong_to(:pet) }
    it { should belong_to(:application) }
  end

  describe 'check_if_completed' do
    describe 'changes the application depending on completion status' do
      before(:each) do
        shelter1 = Shelter.create!(foster_program: true, name: 'Dumb Friends League', city: 'Denver', rank: 7)

        @pet_1 = Pet.create!(adoptable: true, age: 7, breed: 'Golden Retriever', name: 'Brownie', shelter_id: shelter1.id)
        @pet_2 = Pet.create!(adoptable: true, age: 7, breed: 'Husky', name: 'Snow', shelter_id: shelter1.id)

        @application = Application.create!(name: 'Bob Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "Pending")
      end

      it 'accepts application if all pets are approved' do
        app_pet_1 = ApplicationPet.create!(application: @application, pet: @pet_1, accepted: true)
        @application.check_if_completed

        expect(@application.status).to eq("Approved")
      end

      it 'rejects application if all pets are either approved or denied and at least one is denied' do
        app_pet_2 = ApplicationPet.create!(application: @application, pet: @pet_1, accepted: true)
        app_pet_3 = ApplicationPet.create!(application: @application, pet: @pet_2, accepted: false)
        @application.check_if_completed

        expect(@application.status).to eq("Rejected")
      end

      it 'does nothing otherwise' do
        app_pet_4 = ApplicationPet.create!(application: @application, pet: @pet_1, accepted: nil)
        app_pet_5 = ApplicationPet.create!(application: @application, pet: @pet_2, accepted: true)
        @application.check_if_completed

        expect(@application.status).to eq("Pending")
      end
    end
  end
end
