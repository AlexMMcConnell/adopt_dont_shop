class CreateApplicationPets < ActiveRecord::Migration[5.2]
  def change
    create_table :application_pets do |t|
      t.integer :pet_id
      t.integer :application_id

      t.timestamps
    end
  end
end
