class CreateScoreControls < ActiveRecord::Migration[5.0]
  def change
    create_table :score_controls do |t|
      t.boolean :begin_status  ,default:false
      t.boolean :end_status ,default:false
      t.integer :round_number
      t.boolean :status  ,default:true

      t.timestamps
    end
  end
end
