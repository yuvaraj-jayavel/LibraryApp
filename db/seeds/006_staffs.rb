admin_role = Role.find_or_create_by(name: 'ADMIN')
librarian_role = Role.find_or_create_by(name: 'LIBRARIAN')

Staff.create(username: 'admin', password: 'muthamizh', role: admin_role)
Staff.create(username: 'library', password: 'mandram', role: librarian_role)
