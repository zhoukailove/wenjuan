class CreateScoreRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :score_records do |t|
      t.integer :user_id
      t.integer :control_id
      t.integer :number ,default:0
      t.integer :fraction ,default:0
      t.boolean :status ,default:false

      t.timestamps
    end
  end
end
