# frozen_string_literal: true

require 'test_helper'

class BookTest < ActiveSupport::TestCase
  def setup
    @author = Author.create(name: 'Chetan Bhagat')
    @category1 = Category.create(name: 'Romance')
    @category2 = Category.create(name: 'Young Adult')
    @publisher = Publisher.create(name: 'Kalki')

    @book_name = 'The Shining'
    @author_name = 'Sidney Sheldon'
    @publisher_name = 'Rosetta Publications'
    @publishing_year = 2002
    @categories = 'Trauma, Women'
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

  test 'can create with associated models' do
    assert_difference -> { Book.count } => 1, -> { Author.count } => 1, -> { Publisher.count } => 1,
                      -> { Category.count } => 2 do
      book = Book.create_with_associated_models(name: @book_name, author_name: @author_name,
                                                publisher_name: @publisher_name, publishing_year: @publishing_year,
                                                categories: @categories)
      assert book.valid?
      assert_equal book.name, @book_name
      assert_equal book.author.name, @author_name
      assert_equal book.publisher.name, @publisher_name
      assert_equal book.publishing_year, @publishing_year
      assert_includes @categories, book.categories.first.name
      assert_includes @categories, book.categories.second.name
    end
  end

  test 'cannot create with associated models when book name is missing' do
    book = Book.create_with_associated_models(name: nil, author_name: @author_name,
                                              publisher_name: @publisher_name, publishing_year: @publishing_year,
                                              categories: @categories)
    assert book.invalid?
  end

  test 'cannot create with associated models when author name is missing' do
    book = Book.create_with_associated_models(name: @book_name, author_name: nil,
                                              publisher_name: @publisher_name, publishing_year: @publishing_year,
                                              categories: @categories)
    assert book.invalid?
  end

  test 'can create with associated models when publisher name is missing' do
    book = Book.create_with_associated_models(name: @book_name, author_name: @author_name,
                                              publisher_name: nil, publishing_year: @publishing_year,
                                              categories: @categories)
    assert book.valid?
  end

  test 'can create with associated models when publishing year is missing' do
    book = Book.create_with_associated_models(name: @book_name, author_name: @author_name,
                                              publisher_name: @publisher_name, publishing_year: nil,
                                              categories: @categories)
    assert book.valid?
  end

  test 'can create with associated models when categories is missing' do
    book = Book.create_with_associated_models(name: @book_name, author_name: @author_name,
                                              publisher_name: @publisher_name, publishing_year: nil,
                                              categories: nil)
    assert book.valid?
  end

  test 'new author is not created when author_name is given as existing author name' do
    existing_author_name = @author.name
    assert_difference -> { Book.count } => 1, -> { Author.count } => 0 do
      book = Book.create_with_associated_models(name: @book_name, author_name: existing_author_name,
                                                publisher_name: @publisher_name, publishing_year: nil,
                                                categories: nil)
      assert_equal book.author.name, existing_author_name
      assert book.valid?
    end
  end

  test 'new publisher is not created when publisher_name is given as existing publisher name' do
    existing_publisher_name = @publisher.name
    assert_difference -> { Book.count } => 1, -> { Publisher.count } => 0 do
      book = Book.create_with_associated_models(name: @book_name, author_name: @author_name,
                                                publisher_name: existing_publisher_name, publishing_year: nil,
                                                categories: nil)
      assert_equal book.publisher.name, existing_publisher_name
      assert book.valid?
    end
  end

  test 'new category is not created when category is given as existing category name' do
    existing_category1_name = @category1.name
    existing_category2_name = @category2.name
    assert_difference -> { Book.count } => 1, -> { Category.count } => 0 do
      book = Book.create_with_associated_models(name: @book_name, author_name: @author_name,
                                                publisher_name: @publisher_name, publishing_year: nil,
                                                categories: "#{existing_category1_name}, #{existing_category2_name}")
      assert_equal book.categories.map(&:name).sort, [existing_category1_name, existing_category2_name].sort
      assert book.valid?
    end
  end

  test 'should rollback associated models creation when book create validation fails' do
    assert_no_difference ['Book.count', 'Author.count', 'Publisher.count', 'Category.count'] do
      book = Book.create_with_associated_models(name: nil, author_name: @author_name,
                                                publisher_name: @publisher_name, publishing_year: @publishing_year,
                                                categories: @categories)
      # name is blank and hence book create is invalid
      assert book.invalid?
    end
  end
end
