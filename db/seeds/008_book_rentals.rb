book1 = Book.first
book2 = Book.second
member1 = Member.first
member2 = Member.second

BookRental.create(
  book: book1,
  member: member1,
  issued_on: Date.today
)

BookRental.create(
  book: book2,
  member: member2,
  issued_on: 10.days.ago,
  returned_on: 2.days.ago
)
