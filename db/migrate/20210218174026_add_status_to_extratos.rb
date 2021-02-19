class AddStatusToExtratos < ActiveRecord::Migration[6.1]
  def change
    add_column :extratos, :status, :boolean
  end
end
