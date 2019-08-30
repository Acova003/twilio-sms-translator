class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :phoneNumber
      t.string :language
      t.string :content
    end
  end
end
