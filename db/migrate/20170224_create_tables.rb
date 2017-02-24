class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.integer :size
      t.timestamps

    end
    create_table :caches do |t|
      t.integer :size
      t.timestamps
    end
    create_table :endpoints do |t|
      t.integer :lat
      t.timestamps
    end
    create_table :connections do |t|
      t.integer :lat
      t.integer :cache_id
      t.integer :endpoint_id
      t.timestamps
    end
    create_table :requests do |t|
      t.integer :count
      t.integer :video_id
      t.integer :endpoint_id
      t.timestamps
    end
    create_table :solutions do |t|
      t.integer :video_id
      t.integer :cache_id
      t.timestamps
    end
  end

  def self.down
  end
end