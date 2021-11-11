class MemberBookRentalsController < ApplicationController
  def index
    @member_book_rentals = BookRental.current.includes(:book).where(member_id: member_book_rentals_params[:member_id])
    @returning_on = returning_on
    respond_to do |format|
      format.html { render partial: 'member_book_rentals' }
      format.json { render json: @member_book_rentals }
    end
  end

  private

  def returning_on
    member_book_rentals_params[:returning_on]&.to_date
  rescue Date::Error => e
    Date.today
  end

  def member_book_rentals_params
    params.permit(:member_id, :returning_on)
  end
end
