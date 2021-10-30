require "test_helper"

class StaffTest < ActiveSupport::TestCase
  def setup
    @admin_role = Role.create(name: 'ADMIN')
    @librarian_role = Role.create(name: 'LIBRARIAN')
  end

  test 'should be valid' do
    admin_staff = Staff.new(username: 'admin', password: 'muthamizh', role: @admin_role)
    librarian_staff = Staff.new(username: 'library', password: 'mandram', role: @librarian_role)

    assert admin_staff.valid?
    assert librarian_staff.valid?
  end

  test 'should identify admin staff with admin?' do
    admin_staff = Staff.new(username: 'admin', password: 'muthamizh', role: @admin_role)
    librarian_staff = Staff.new(username: 'library', password: 'mandram', role: @librarian_role)

    assert admin_staff.admin?
    assert_not librarian_staff.admin?
  end

  test 'should identify librarian staff with librarian?' do
    librarian_staff = Staff.new(username: 'library', password: 'mandram', role: @librarian_role)
    admin_staff = Staff.new(username: 'admin', password: 'muthamizh', role: @admin_role)

    assert librarian_staff.librarian?
    assert_not admin_staff.librarian?
  end
end
