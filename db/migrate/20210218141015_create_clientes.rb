class CreateClientes < ActiveRecord::Migration[6.1]
  def change
    create_table :clientes do |t|
      t.string :nome
      t.string :email
      t.string :password_digest
      t.string :conta
      t.float :saldo

      t.timestamps
    end
    add_index :clientes, :email, unique: true
  end
end
