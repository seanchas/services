class AuthorizedUrlInfosellResources < ActiveRecord::Migration
  def self.up
    create_table :authorized_url_infosell_resources do |t|
      t.integer :authorized_url_id
      t.string  :elementary_resource_id
      t.timestamps
    end
    
    add_index :authorized_url_infosell_resources, [:authorized_url_id, :elementary_resource_id], :name => "relation_index"
  end

  def self.down
    remove_index :authorized_url_infosell_resources, :name => :relation_index

    drop_table :authorized_url_infosell_resources
  end
end
