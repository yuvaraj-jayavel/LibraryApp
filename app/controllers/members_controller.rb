class MembersController < ApplicationController
  def index
    authorize Member
    @pagy, @members = pagy(Member.search(member_search_params[:search]),
                           items: member_search_params[:max_results] || Pagy::DEFAULT[:items])
    respond_to do |format|
      format.html
      format.json { render json: @members }
    end
  end

  def new
    @member = Member.new
    authorize @member
  end

  def create
    authorize Member
    @member = Member.new(member_params)
    if @member.save
      flash[:snack_success] = I18n.t('successfully_created_member_name', name: @member.name)
      redirect_to members_path
    else
      flash[:form_errors] = @member.errors.full_messages
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

  def member_search_params
    params
      .transform_values { |x| x.strip.gsub(/\s+/, ' ') if x.respond_to?('strip') }
      .permit(:search, :max_results)
  end
end
