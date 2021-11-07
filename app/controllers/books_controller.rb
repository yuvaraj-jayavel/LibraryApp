class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new
    @book = Book.new
    authorize @book
  end

  def create
    authorize Book
    @book = Book.create_with_associated_models(book_params)
    if @book.valid?
      flash[:snack_success] = "Successfully created book #{@book.name}"
      redirect_to books_path
    else
      redirect_to new_book_path
      flash[:form_errors] = @book.errors.full_messages
    end
  end

  private

  def book_params
    params
      .require(:book)
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .permit(:name, :author_name, :publisher_name, :publishing_year, :category_names)
  end
end
