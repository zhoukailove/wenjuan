class CreateScoreControlCenters < ActiveRecord::Migration[5.0]
  def change
    create_table :score_control_centers do |t|
      t.datetime :begin_time
      t.datetime :end_time
      t.integer :fraction
      t.integer :people_number
      t.integer :round_number
      t.boolean :status  ,default:true

      t.timestamps
    end
  end
end
