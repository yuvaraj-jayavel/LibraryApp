class MemberBookRentalsController < ApplicationController
  def index
    @member_book_rentals = BookRental.current.where(member_id: member_book_rentals_params[:member_id])
    respond_to do |format|
      format.html { render partial: 'member_book_rentals_as_checkboxes' }
      format.json { render json: @member_book_rentals }
    end
  end

  private

  def member_book_rentals_params
    params.permit(:member_id)
  end
end
