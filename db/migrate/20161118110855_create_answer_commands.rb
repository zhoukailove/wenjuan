class CreateAnswerCommands < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_commands do |t|
      t.integer :answer_id
      t.datetime :begin_time
      t.datetime :end_time
      t.boolean :status ,default:1

      t.timestamps
    end
  end
end
