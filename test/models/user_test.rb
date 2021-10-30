require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @admin_role = Role.create(name: 'ADMIN')
    @librarian_role = Role.create(name: 'LIBRARIAN')
    @member_role = Role.create(name: 'MEMBER')

    @member_user = User.new(
      member_id: '1',
      name: 'Member Tron',
      phone: '1234567890',
      email: 'tron@example.com',
      role: @member_role,
      password: "abcd1234",
      password_confirmation: "abcd1234"
    )
  end

  test 'should be valid' do
    assert @member_user.valid?
  end

  test 'should have member_id' do
    @member_user.member_id = ''
    assert @member_user.invalid?
    @member_user.member_id = nil
    assert @member_user.invalid?
  end

  test 'should have name' do
    @member_user.name = ''
    assert @member_user.invalid?
    @member_user.name = nil
    assert @member_user.invalid?
  end

  test 'email can be blank' do
    @member_user.email = ''
    assert @member_user.valid?
    @member_user.email = nil
    assert @member_user.valid?
  end

  test 'email validation should accept emails in proper format' do
    valid_addresses = %w[user@example.com User@exaMple.com A_us-02@example.org.bar first.last@e.co user+name@c.in]

    valid_addresses.each do |address|
      @member_user.email = address
      assert @member_user.valid?, "#{address.inspect} should be valid"
    end
  end

  test 'email validation should reject emails in improper format' do
    valid_addresses = %w[1&user@example.com User_at_exaMple.com A_us-02@example.org. first.last@e_co user@c+in.in]

    valid_addresses.each do |address|
      @member_user.email = address
      assert @member_user.invalid?, "#{address.inspect} should be invalid"
    end
  end

  test 'email should be unique when present' do
    user = User.new(
      member_id: '1',
      name: 'Member Tron',
      phone: '1234567890',
      email: 'member@tron.com',
      role: @member_role,
      password: 'abcd1234',
      password_confirmation: 'abcd1234'
    )
    another_user_with_same_email = User.new(
      member_id: '2',
      name: 'Member Begweo',
      phone: '1234554321',
      email: 'member@tron.com',
      role: @member_role,
      password: 'abcd1234',
      password_confirmation: 'abcd1234'
    )
    user.save
    assert another_user_with_same_email.invalid?
    assert another_user_with_same_email.errors.include? :email
  end

  test 'email can be non-unique when not given (blank)' do
    user_without_email = User.new(
      member_id: '1',
      name: 'Member Tron',
      phone: '1234567890',
      email: '',
      role: @member_role,
      password: 'abcd1234',
      password_confirmation: 'abcd1234'
    )
    user_without_email.save
    another_user_without_email = User.new(
      member_id: '2',
      name: 'Member Begweo',
      phone: '1234554321',
      email: '',
      role: @member_role,
      password: 'abcd1234',
      password_confirmation: 'abcd1234'
    )
    assert another_user_without_email.valid?
  end

  test 'should have a role' do
    @member_user.role = nil
    assert @member_user.invalid?
  end

  test 'password should be at least 6 chars' do
    user = User.new(
      member_id: '1',
      name: 'Member Tron',
      phone: '1234567890',
      email: 'user@example.com',
      role: @member_role,
      password: 'abcde',
      password_confirmation: 'abcde'
    )
    assert user.invalid?

    user = User.new(
      member_id: '1',
      name: 'Member Tron',
      phone: '1234567890',
      email: 'user@example.com',
      role: @member_role,
      password: 'abcdef',
      password_confirmation: 'abcdef'
    )
    assert user.valid?
  end

  test 'member_id should be unique' do
    user = User.new(
      member_id: '1',
      name: 'Member Tron',
      phone: '1234567890',
      email: 'member@tron.com',
      role: @member_role,
      password: 'abcd1234',
      password_confirmation: 'abcd1234'
    )
    user.save
    another_user_with_same_member_id = User.new(
      member_id: '1',
      name: 'Member Begweo',
      phone: '1234554321',
      email: 'member@begweo.com',
      role: @member_role,
      password: 'abcd1234',
      password_confirmation: 'abcd1234'
    )
    assert another_user_with_same_member_id.invalid?
    assert another_user_with_same_member_id.errors.include? :member_id
  end

  test 'phone should be unique' do
    user = User.new(
      member_id: '1',
      name: 'Member Tron',
      phone: '1234567890',
      email: 'member@tron.com',
      role: @member_role,
      password: 'abcd1234',
      password_confirmation: 'abcd1234'
    )
    user.save
    another_user_with_same_phone = User.new(
      member_id: '2',
      name: 'Member Begweo',
      phone: '1234567890',
      email: 'member@begweo.com',
      role: @member_role,
      password: 'abcd1234',
      password_confirmation: 'abcd1234'
    )
    assert another_user_with_same_phone.invalid?
    assert another_user_with_same_phone.errors.include? :phone
  end

  test 'phone should be exactly 10 digits' do
    @member_user.phone = '123456789'
    assert @member_user.invalid?
    assert @member_user.errors.include? :phone

    @member_user.phone = '12345678901'
    assert @member_user.invalid?
    assert @member_user.errors.include? :phone

    @member_user.phone = '12345ab$ 1'
    assert @member_user.invalid?
    assert @member_user.errors.include? :phone

    @member_user.phone = '1234567890'
    assert @member_user.valid?
  end
end
