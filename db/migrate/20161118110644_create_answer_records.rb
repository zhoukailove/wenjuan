class CreateAnswerRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_records do |t|
      t.integer :user_id
      t.integer :answer_id
      t.integer :time_cost
      t.boolean :status,default:0 #0答错1答对2未答

      t.timestamps
    end
  end
end
