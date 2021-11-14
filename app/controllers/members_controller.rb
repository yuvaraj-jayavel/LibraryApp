class MembersController < ApplicationController
  def index
    authorize Member
    @members = Member.search(member_search_params[:search])
  end

  def new
    @member = Member.new
    authorize @member
  end

  def create
    authorize Member
    @member = Member.create(member_params)
    if @member.valid?
      flash[:snack_success] = "Successfully created member #{@member.name}"
      redirect_to members_path
    else
      flash[:form_errors] = @member.errors.full_messages
      redirect_to new_member_path
    end
  end

  def member_params
    params
      .require(:member)
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .reject { |_k, v| v.blank? }
      .permit(:name, :personal_number, :email, :phone, :father_name, :date_of_birth, :date_of_retirement)
  end

  def member_search_params
    params
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .permit(:search)
  end
end
