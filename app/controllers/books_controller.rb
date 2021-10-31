class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.create_with_associated_models(book_params)
    if @book.valid?
      redirect_to books_path
    else
      render 'new'
    end
  end

  private

  def book_params
    params
      .require(:book)
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .permit(:name, :author_name, :publisher_name, :publishing_year, :categories)
  end
end
