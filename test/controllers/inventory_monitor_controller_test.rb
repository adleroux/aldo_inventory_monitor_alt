require "test_helper"

class InventoryMonitorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get inventory_monitor_index_url
    assert_response :success
  end
end
