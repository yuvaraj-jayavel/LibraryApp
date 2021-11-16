class BookRentalsController < ApplicationController
  def index
    authorize BookRental
    @pagy, @book_rentals = pagy(BookRental
                                  .includes(:book, :member)
                                  .filter_by(book_rental_filter_params.slice(:only_current))
                                  .search(book_rental_filter_params[:search]))
  end

  def new
    authorize BookRental
    @book_rental = BookRental.new
  end

  def create
    authorize BookRental
    @book_rental = BookRental.create(book_rental_params)
    if @book_rental.valid?
      flash[:snack_success] = "Successfully created rental. Due by #{@book_rental.due_by}"
      redirect_to book_rentals_path
    else
      flash.now[:form_errors] = @book_rental.errors.full_messages
      render 'new'
    end
  end

  private

  def book_rental_params
    params
      .require(:book_rental)
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .reject { |_k, v| v.blank? }
      .permit(:book_id, :member_id, :issued_on)
  end

  def book_rental_filter_params
    params
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .permit(:search, :only_current)
  end
end
