admin_role = Role.find_by(name: 'admin')
librarian_role = Role.find_by(name: 'librarian')
member_role = Role.find_by(name: 'member')

User.create(
  member_id: '1',
  name: 'Jerry Admin',
  phone: '1111111111',
  email: 'jerry_admin@example.com',
  role: admin_role,
)
