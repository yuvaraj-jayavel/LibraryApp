module SessionsHelper

  def log_in(staff)
    session[:staff_id] = staff.id
  end

  def current_staff
    if session[:staff_id]
      @current_staff ||= Staff.find_by(id: session[:staff_id])
    end
  end

  def logged_in?
    !current_staff.nil?
  end

  def log_out
    session.delete(:staff_id)
    @current_staff = nil
  end
end
