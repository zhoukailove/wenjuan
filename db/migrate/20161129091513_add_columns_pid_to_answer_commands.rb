class AddColumnsPidToAnswerCommands < ActiveRecord::Migration[5.0]
  def change
    add_column :answer_commands, :pid, :integer
  end
end
