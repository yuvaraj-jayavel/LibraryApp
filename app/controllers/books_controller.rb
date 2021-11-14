class BooksController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @pagy, @books = pagy(Book.includes(:author, :publisher, :categories).search(book_search_params[:search]))
        render 'index'
      end
      format.json do
        @books = Book.includes(:author).search(book_search_params[:search],
                                                                        book_search_params[:max_results])
        render json: @books, include: { author: { only: :name } }
      end
    end
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

  def book_search_params
    params
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .permit(:search, :max_results)
  end
end
