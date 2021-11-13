class ReturnsController < ApplicationController
  def new
    authorize BookRental
    @book_rental = BookRental.new
  end

  def create
    authorize BookRental
    @book_rentals = BookRental.current.where(member_id: return_params[:member_id], id: return_params[:book_rental_ids])
    if @book_rentals.count.zero?
      flash[:form_error] = 'Book rentals not found for given member'
    else
      @book_rentals.update(returned_on: return_params[:returned_on])
      flash[:snack_success] = "Successfully returned books for member ##{return_params[:member_id]}"
    end

    redirect_to new_return_path
  end

  def return_params
    params
      .require(:return)
      .permit(:member_id, :returned_on, book_rental_ids: [])
  end
end
