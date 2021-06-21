class ReceiptsController < ApplicationController
  def show
    @receipt = Receipt.find_by(auth_code: params[:id])
  end
end