class CreateScoreUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :score_users do |t|
      t.string :name
      t.boolean :status ,default:true
      t.boolean :state  ,default:false

      t.timestamps
    end
  end
end
