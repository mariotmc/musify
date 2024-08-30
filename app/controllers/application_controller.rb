class ApplicationController < ActionController::Base
  include Authentication
  include SetCurrentRequestDetails
  include ActiveStorage::SetCurrent
end
