class BookRentalsController < ApplicationController
  def index
    @book_rentals = BookRental.all
  end

  def new
    @book_rental = BookRental.new
  end

  def create
    @book_rental = BookRental.create(book_rental_params)
    if @book_rental.valid?
      redirect_to book_rentals_path
    else
      flash.now[:danger] = @book_rental.errors.full_messages
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
end
