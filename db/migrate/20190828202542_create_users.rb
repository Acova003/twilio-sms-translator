class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :phoneNumber
      t.string :language
    end 
  end
end
