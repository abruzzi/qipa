class CreateExoticPlants < ActiveRecord::Migration
    def change
        create_table :plants do |t|
            t.string :name
            t.text :description

            t.timestamps
        end
    end
end

