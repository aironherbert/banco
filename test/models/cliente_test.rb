require "test_helper"

class ClienteTest < ActiveSupport::TestCase
  def setup
    @cliente = Cliente.new(nome: "Example User", email: "cliente@example.com", 
                      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @cliente.valid?
  end
  
  test "nome should be present" do
    @cliente.nome = "  "
    assert_not @cliente.valid?
  end

  test "email should be present" do
    @cliente.email = "  "
    assert_not @cliente.valid?
  end

  test "nome should not be too long" do
    @cliente.nome = "a" * 51
    assert_not @cliente.valid?
  end

  test "email should not be too long" do
    @cliente.email = "a" * 244 + "@example.com"
    assert_not @cliente.valid? 
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
    first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @cliente.email = valid_address
      assert @cliente.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
    foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
    @cliente.email = invalid_address
    assert_not @cliente.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_cliente = @cliente.dup
    @cliente.save
    assert_not duplicate_cliente.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @cliente.email = mixed_case_email
    @cliente.save
    assert_equal mixed_case_email.downcase, @cliente.reload.email
  end

  test "password should be present (nonblank)" do
    @cliente.password = @cliente.password_confirmation = " " * 6
    assert_not @cliente.valid?
  end

  test "password should have a minimum length" do
    @cliente.password = @cliente.password_confirmation = "a" * 5
    assert_not @cliente.valid?
  end
end
