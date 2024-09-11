Aldo Inventory Monitor
======================

Overview
--------

This project provides a comprehensive inventory monitoring solution for Aldo Stores, featuring real-time updates, an alert system, a REST API, and a full frontend interface. The key components of this solution include:

-   **WebSocket Integration**: Captures real-time updates from ALDO stores.
-   **Frontend Interface**: Built with JavaScript to handle WebSocket messages and display updates live.
-   **Alert System**: Monitors inventory levels and generates alerts based on predefined thresholds.
-   **REST API**: Allows for creating and updating inventory records with validation and error handling.
-   **Database System**: Stores inventory data with a seeding script to initialize the database.

Getting Started
---------------

### Prerequisites

1.  **Ruby**: Ensure Ruby is installed. Recommended version: 3.2.0 or later.
2.  **Rails**: Ensure Rails is installed. Recommended version: 7.0 or later.
3.  **SQLite3**: Ensure SQLite3 is installed for the database.

### Setup

1.  **Clone the Repository**

    `git clone https://github.com/your-username/aldo_inventory_monitor.git`

    `cd aldo_inventory_monitor`

2.  **Install Dependencies**

    `bundle install`

3.  **Set Up the Database**

    Create and migrate the database:

    `rails db:create`

    `rails db:migrate`

    Seed the database with initial data:

    `rails db:seed`

4.  **Start the WebSocket Server**

    Ensure that you have a WebSocket server running on `ws://localhost:8080/` to send inventory updates.

5.  **Start the Rails Server**

    `rails server`

    By default, the server will be available at `http://localhost:3000`.

### Frontend

-   The frontend interface listens for WebSocket messages and updates the inventory table in real-time.
-   Alerts are displayed based on inventory levels and updated dynamically.

### REST API

-   **Endpoint**: `/api/inventories`
-   **Method**: POST
-   **Description**: Creates or updates an inventory record based on the provided data.
-   **Content-Type**: `application/json`

### Testing

1.  **Run Controller Tests**

    `rails test test/controllers/api/inventories_controller_test.rb`

    `rails test test/controllers/inventory_monitor_controller_test.rb`

2.  **Run All Tests**

    `rails test`

Commands Summary
----------------

-   **Start Rails Server**: `rails server`
-   **Migrate Database**: `rails db:migrate`
-   **Seed Database**: `rails db:seed`
-   **Run Tests**: `rails test`
-   **Run WebSocket Server**: Ensure the WebSocket server is running on `ws://localhost:8080/`.