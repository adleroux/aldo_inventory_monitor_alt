class InventoryMonitorController < ApplicationController
  def index
    @stores = Store.all
    @shoe_models = ShoeModel.all
    @inventories = Inventory.includes(:store, :shoe_model).all
    @alerts = generate_initial_alerts

    EM.run do
      ws = Faye::WebSocket::Client.new("ws://localhost:8080/")

      ws.on :message do |event|
        inventory_event = JSON.parse(event.data)

        if valid_inventory_data?(inventory_event)
          store = Store.find_or_create_by(name: inventory_event["store"])
          shoe_model = ShoeModel.find_or_create_by(name: inventory_event["model"])
          inventory = Inventory.find_or_initialize_by(store: store, shoe_model: shoe_model)

          inventory.quantity = inventory_event["inventory"]
          if inventory.save
            puts "Successfully saved inventory data: #{inventory_event}"

            # Check if inventory is too low or too high and add alerts
            if inventory.quantity < 6
              @alerts << { store: store.name, model: shoe_model.name, message: "Inventory is too low" }
            elsif inventory.quantity >= 95
              @alerts << { store: store.name, model: shoe_model.name, message: "Inventory is too high" }
            end

            # Use ActionCable to broadcast the data to the client-side in real-time
            ActionCable.server.broadcast("inventory_channel", inventory_event)
          else
            puts "Failed to save inventory data: #{inventory.errors.full_messages}"
          end
        else
          puts "Invalid inventory data received: #{event.data}"
        end
      end
    end
  end

  private

  def valid_inventory_data?(data)
    required_keys = %w[store model inventory]
    # Check for required keys and data types
    required_keys.all? { |key| data.key?(key) } &&
      data["store"].is_a?(String) &&
      data["model"].is_a?(String) &&
      data["inventory"].is_a?(Integer)
  end

  def generate_initial_alerts
    alerts = []

    Inventory.includes(:store, :shoe_model).find_each do |inventory|
      if inventory.quantity < 6
        alerts << { store: inventory.store.name, model: inventory.shoe_model.name, message: "Inventory is too low" }
      elsif inventory.quantity >= 95
        alerts << { store: inventory.store.name, model: inventory.shoe_model.name, message: "Inventory is too high" }
      end
    end

    alerts
  end
end
