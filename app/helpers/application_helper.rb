module ApplicationHelper
  def authenticated_with_moneybird?
    session[:moneybird_access_token].present?
  end
end
