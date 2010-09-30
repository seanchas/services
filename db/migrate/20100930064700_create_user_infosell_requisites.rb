class CreateUserInfosellRequisites < ActiveRecord::Migration
  def self.up
    create_table :user_infosell_requisites do |t|
      t.integer :user_id
      t.string  :infosell_code
      t.boolean :is_current
      t.timestamps
    end
    
    add_index :user_infosell_requisites, :user_id
  end

  def self.down
    remove_index :user_infosell_requisites, :user_id

    drop_table :user_infosell_requisites
  end
end
