book1 = Book.first
book2 = Book.second
member1 = Member.first
member2 = Member.second

BookRental.create(
  book: book1,
  member: member1,
  issued_at: Time.now
)

BookRental.create(
  book: book2,
  member: member2,
  issued_at: 10.days.ago,
  returned_at: 2.days.ago
)
