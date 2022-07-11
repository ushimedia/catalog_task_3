class CartsController < ApplicationController
    before_action :setup_cart_item!, only: %i[ add_item update_item delete_item]

    # カート内アイテムの表示
    def my_cart
      @cart_items = current_cart.cart_items.includes([:product])
      @total = @cart_items.inject(0) { |sum, item| sum + item.sum_of_price }
      @total_item = @cart_items.inject(0) { |sum, item| sum + item.quantity }
      @regulars = Regular.where(user_id: current_user.id)
    end
  
    # アイテムの追加
    def add_item
      @cart_item ||= current_cart.cart_items.build(product_id: params[:product_id])
      @cart_item.quantity += params[:quantity].to_i
      if  @cart_item.save
        flash[:notice] = '商品が追加されました。'
        redirect_to root_path
      else
        flash[:alert] = '商品の追加に失敗しました。'
        redirect_to product_url(params[:product_id])
      end
    end

    def add_regular
      @regular = Regular.find_or_initialize_by(user_id: current_user.id, regular_number: params[:regular_number])
      @regular.save
      regular_product = RegularProduct.find_or_initialize_by(regular_id: @regular.id, product_id: params[:product_id])
      regular_product.product_id = params[:product_id]
      regular_product.regular_quantity = params[:regular_quantity]
      regular_product.regular_id = @regular.id
      regular_product.save!     
      if  @regular.save
        flash[:notice] = '商品が"いつものあれ"リストに追加されました。「管理」⇒「いつものあれリスト」からも確認できます。'
        redirect_to product_url(params[:product_id])
      else
        flash[:alert] = '"いつものあれ"リストへの追加に失敗しました。'
        redirect_to product_url(params[:product_id])
      end
    end

    def recall_regular
      @regular = Regular.find_by(user_id: current_user.id, regular_number: params[:regular_number])
      @r = RegularProduct.where(regular_id: @regular)
      begin
        ActiveRecord::Base.transaction do
          @r.each do |r|
          @cart_item = current_cart.cart_items.find_or_initialize_by(product_id: r.product_id)
          @cart_item.quantity += r.regular_quantity.to_i
          @cart_item.cart_id ||= Cart.find(user_id: current_user.id) 
          @product = Product.find_by(id: r.product_id)
            if @cart_item.quantity <= @product.stock
          @cart_item.save!
            else
          raise 
          end
        end
        flash[:notice] = '"いつものあれ"リストから呼び出されました。'
        redirect_to my_cart_path
        end
        rescue
        flash[:alert] = '在庫数が不足しており"いつものあれ"リストの商品を必要数カートに入れることができませんでした。'
        redirect_to my_cart_path
      end
    end
  
    # アイテムの更新
    def update_item
      if @cart_item.update(quantity: params[:quantity].to_i)
        flash[:notice] = 'カート内のアイテムが更新されました。'
      else
        flash[:alert] = 'カート内のアイテムの更新に失敗しました。'
      end
      redirect_to my_cart_path
    end
  
    # アイテムの削除
    def delete_item
      if @cart_item.destroy
        flash[:notice] = 'カート内のアイテムが削除されました。'
      else
        flash[:alert] = '削除に失敗しました。'
      end
      redirect_to my_cart_path
    end

    def delete_regular
      @regulars = Regular.find_by(user_id: current_user.id, product_id: params[:product_id])
      if @regulars.destroy
        flash[:notice] = '"いつものあれ"リストから正常に削除されました。'
      else
        flash[:alert] = '"いつものあれ"リストからの削除に失敗しました。'
      end
      redirect_to product_url(params[:product_id])
    end
  
    private
  
    def setup_cart_item!
      @cart_item = current_cart.cart_items.find_by(product_id: params[:product_id])
    end


end
