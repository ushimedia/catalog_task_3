class RegularsController < ApplicationController
    def index

       @regulars = Regular.where(user_id: current_user.id).order(regular_number: "ASC")

      end


end
