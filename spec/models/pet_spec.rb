require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end
  end

  describe 'accepted' do
    before(:each) do
      @app_1 = Application.create!(name: 'Bob Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "Pending")
      @app_2 = Application.create!(name: 'Jane Smith', street_address: '321 Eve Way', city: 'Aurora', state: 'Colorado', zip_code: '80222', status: "Pending")
      ApplicationPet.create!(application: @app_1, pet: @pet_1, accepted: true)
      ApplicationPet.create!(application: @app_2, pet: @pet_2, accepted: false)
    end

    it 'returns true if app_pet is accepted' do

      expect(@pet_1.accepted?(@app_1.id)).to eq(true)
    end

    it 'returns false if app_pet is denied' do

      expect(@pet_2.accepted?(@app_2.id)).to eq(false)
    end
  end
end
