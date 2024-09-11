module Api
  class InventoriesController < ApplicationController
    protect_from_forgery with: :null_session # Disable CSRF protection for API requests

    def create
      # Ensure that store and model are present before finding or creating
      if inventory_params[:store].blank? || inventory_params[:model].blank?
        return render json: { errors: [ "Store can't be blank", "Model can't be blank" ] }, status: :unprocessable_entity
      end

      # Find or create the associated store and shoe model
      store = Store.find_or_create_by(name: inventory_params[:store])
      shoe_model = ShoeModel.find_or_create_by(name: inventory_params[:model])

      # Find the inventory record if it exists
      inventory = Inventory.find_or_initialize_by(store: store, shoe_model: shoe_model)
      inventory.quantity = inventory_params[:inventory]

      if inventory.valid? && inventory.save
        render json: { message: "Inventory updated successfully", inventory: inventory }, status: :ok
      else
        render json: { errors: inventory.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def inventory_params
      params.require(:inventory).permit(:store, :model, :inventory)
    end
  end
end
