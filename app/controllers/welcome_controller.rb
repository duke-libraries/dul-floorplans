class WelcomeController < ApplicationController
  def index
    @buildings = Building.all()
  end
end
