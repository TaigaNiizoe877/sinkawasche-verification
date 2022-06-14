class Api::CarWashOptionsController < ApplicationController

  def search
    @options = CarWashOption.where("name LIKE(?)", "%#{params[:name].strip}%")
    respond_to do |format|
      format.json { render json: @options }
    end
  end

end