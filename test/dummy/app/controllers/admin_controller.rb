class AdminController < ApplicationController
  before_action :authenticate_admin

  private

  def authenticate_admin
    # This is just a test implementation
    # In real apps, this would check authentication
    true
  end
end
