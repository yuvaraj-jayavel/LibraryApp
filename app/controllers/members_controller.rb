class MembersController < ApplicationController
  def index
    authorize Member
    @members = Member.all
  end

  def new
    @member = Member.new
    authorize @member
  end

  def create
    authorize Member
    @member = Member.create(member_params)
    if @member.valid?
      redirect_to members_path
    else
      render 'new'
    end
  end

  def member_params
    params
      .require(:member)
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .reject { |_k, v| v.blank? }
      .permit(:name, :personal_number, :email, :phone, :father_name, :date_of_birth, :date_of_retirement)
  end
end
