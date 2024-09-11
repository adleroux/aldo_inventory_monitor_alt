require "test_helper"

module Api
  class InventoriesControllerTest < ActionDispatch::IntegrationTest
    # Set up test data before each test
    setup do
      @store_name = "ALDO Eaton Centre"
      @model_name = "Sneakers"
      @initial_inventory = 50
      @updated_inventory = 30

      # Create initial store and shoe model
      @store = Store.create!(name: @store_name)
      @shoe_model = ShoeModel.create!(name: @model_name)
    end

    # Test the create action for new inventory
    test "should create a new inventory" do
      assert_difference("Inventory.count", 1) do
        post api_inventories_url, params: {
          inventory: { store: @store_name, model: @model_name, inventory: @initial_inventory }
        }, as: :json

        assert_response :ok
      end

      # Validate the JSON response
      json_response = JSON.parse(response.body)
      assert_equal "Inventory updated successfully", json_response["message"]
      assert_equal @initial_inventory, json_response["inventory"]["quantity"]
    end

    # Test the update action for existing inventory
    test "should update existing inventory" do
      # Create the inventory record initially
      Inventory.create!(store: @store, shoe_model: @shoe_model, quantity: @initial_inventory)

      assert_no_difference("Inventory.count") do
        post api_inventories_url, params: {
          inventory: { store: @store_name, model: @model_name, inventory: @updated_inventory }
        }, as: :json

        assert_response :ok
      end

      # Validate the JSON response
      json_response = JSON.parse(response.body)
      assert_equal "Inventory updated successfully", json_response["message"]
      assert_equal @updated_inventory, json_response["inventory"]["quantity"]
    end

    # Test for invalid inventory data
    test "should return error for invalid inventory data" do
      post api_inventories_url, params: { inventory: { store: "", model: "", inventory: nil } }, as: :json
      assert_response :unprocessable_entity
      assert_includes response.parsed_body["errors"], "Store can't be blank"
      assert_includes response.parsed_body["errors"], "Model can't be blank"
    end
  end
end
