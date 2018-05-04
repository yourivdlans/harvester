class ApplicationController < ActionController::Base
  helper_method :authenticated_with_moneybird?

  def authenticated_with_moneybird?
    session[:moneybird_access_token].present?
  end
end
