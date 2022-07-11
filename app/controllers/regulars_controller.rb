class RegularsController < ApplicationController
    before_action :set_regular, only: %i[ show edit update destroy ]
    def index

       @regulars = Regular.where(user_id: current_user.id).order(regular_number: "ASC")

      end

    def edit
      end

      def destroy
        @regular.destroy
    
        respond_to do |format|
          format.html { redirect_to regulars_url, notice: "リストは正常に削除されました。" }
          format.json { head :no_content }
        end
      end 

      def set_regular
        @regular = Regular.find(params[:id])
      end
end
