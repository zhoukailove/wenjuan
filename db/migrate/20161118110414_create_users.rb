class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :login_name
      t.string :password
      t.boolean :status ,default:true # 1可以做操作；0不可操作

      t.timestamps
    end
  end
end
