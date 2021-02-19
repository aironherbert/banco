class CreateExtratos < ActiveRecord::Migration[6.1]
  def change
    create_table :extratos do |t|
      t.string :tipo
      t.string :conta_origem
      t.string :conta_destino
      t.float :valor

      t.timestamps
    end
  end
end
