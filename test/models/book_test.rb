# frozen_string_literal: true

require 'test_helper'

class BookTest < ActiveSupport::TestCase
  def setup
    @author = Author.create(name: 'Chetan Bhagat')
    @category1 = Category.create(name: 'Romance')
    @category2 = Category.create(name: 'Young Adult')
    @publisher = Publisher.create(name: 'Kalki')
  end

  test 'should be valid' do
    book = Book.new(
      name: 'New Book',
      publishing_year: 2019,
      author: @author,
      categories: [@category1, @category2],
      publisher: @publisher
    )
    assert book.valid?
  end

  test 'should not have blank name' do
    book = Book.new(
      name: '',
      publishing_year: 2019,
      author: @author,
      categories: [@category1, @category2],
      publisher: @publisher
    )
    assert_not book.valid?
  end

  test 'publishing year can be blank' do
    book = Book.new(
      name: 'New Book',
      author: @author,
      categories: [@category1, @category2],
      publisher: @publisher
    )
    assert book.valid?
  end

  test 'publishing year should be before current year' do
    book = Book.new(
      name: 'New Book',
      publishing_year: Time.now.year.succ,
      author: @author,
      categories: [@category1, @category2],
      publisher: @publisher
    )
    assert book.invalid?
  end

  test 'should not be without an author' do
    book = Book.new(
      name: 'New Book',
      publishing_year: 2019,
      categories: [@category1, @category2],
      publisher: @publisher
    )
    assert book.invalid?
  end

  test 'can have zero categories' do
    book = Book.new(
      name: 'New book',
      publishing_year: 2019,
      author: @author,
      publisher: @publisher
    )
    assert book.valid?
  end

  test 'can be without a publisher' do
    book = Book.new(
      name: 'New Book',
      publishing_year: 2019,
      author: @author,
      categories: [@category1, @category2]
    )
    assert book.valid?
  end
end
