class CreateSuggestions < ActiveRecord::Migration[7.0]
  def change
    create_table :suggestions do |t|
      t.string :message

      t.timestamps
    end
  end
end
