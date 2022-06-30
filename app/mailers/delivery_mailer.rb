class DeliveryMailer < ApplicationMailer

    def delivery_email
        @order = params[:order]
        @user = params[:user]
        mail(from:@user.email ,to: @order.user.email,  subject: '商品発送完了のお知らせ')
      end
end
