class ApplicationController < ActionController::Base
  rescue_from Moneybird::Error, with: :moneybird_error

  helper_method :authenticated_with_moneybird?

  def authenticated_with_moneybird?
    session[:moneybird_access_token].present?
  end

  def moneybird_error(exception)
    if exception.code == 401
      session.delete(:moneybird_access_token)
      redirect_to root_path, alert: 'Your Moneybird token is no longer valid, please re-authenticate.'
    else
      redirect_to root_path, alert: "A moneybird error occurred: #{exception}"
    end
  end
end
