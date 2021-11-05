class MemberBookRentalsController < ApplicationController
  def index
    @member_book_rentals = BookRental.where(member_id: member_book_rentals_params[:member_id])
    render partial: 'member_book_rentals_as_checkboxes'
  end

  private

  def member_book_rentals_params
    params.permit(:member_id)
  end
end
