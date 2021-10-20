# frozen_string_literal: true

authors = Author.all
publishers = Publisher.all
categories = Category.all

Book.create(
  name: 'Great Things To Do',
  publishing_year: 1988,
  publisher: publishers.sample,
  author: authors.sample,
  categories: categories.sample(2)
)

Book.create(
  name: 'How I Met Your Mother',
  publishing_year: 2005,
  publisher: publishers.sample,
  author: authors.sample,
  categories: categories.sample(1)
)

Book.create(
  name: 'Mr. Robot',
  publishing_year: 2013,
  publisher: publishers.sample,
  author: authors.sample,
  categories: categories.sample(3)
)

Book.create(
  name: 'Squid Game',
  publishing_year: 2021,
  publisher: publishers.sample,
  author: authors.sample,
  categories: categories.sample(2)
)
