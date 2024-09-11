import consumer from "./consumer";

const inventoryChannel = consumer.subscriptions.create("InventoryChannel", {
  connected() {
    console.log("Connected to WebSocket");
  },

  disconnected() {
    console.log("Disconnected from WebSocket");
  },

  received(data) {
    console.log("Received data:", data);
    document.getElementById('latest-json').textContent = JSON.stringify(data, null, 2);

    // Update the inventory table with the new data
    updateInventoryTable(data);
  }
});

function updateInventoryTable(data) {
  const tableBody = document.getElementById('inventory-body');
  const headerRow = document.getElementById('header-row');
  
  console.log("Updating inventory table with data:", data);

  const storeName = data.store;
  const modelName = data.model;
  const inventoryQuantity = data.inventory;

  console.log("Store Name:", storeName);
  console.log("Model Name:", modelName);
  console.log("Inventory Quantity:", inventoryQuantity);

  // Find the store column index
  const headerCells = headerRow.getElementsByTagName('th');
  let storeIndex = -1;

  for (let i = 1; i < headerCells.length; i++) { // Start from index 1 to skip the empty header
    if (headerCells[i].textContent.trim() === storeName) {
      storeIndex = i;
      break;
    }
  }

  console.log("Store Index:", storeIndex);

  // Find the model row and update the store cell
  const rows = tableBody.getElementsByTagName('tr');
  let modelRow = null;

  for (let row of rows) {
    const modelCell = row.getElementsByTagName('td')[0];
    if (modelCell && modelCell.textContent.trim() === modelName) {
      modelRow = row;
      break;
    }
  }

  if (modelRow && storeIndex >= 0) {
    const cells = modelRow.getElementsByTagName('td');
    const storeCell = cells[storeIndex];

    if (storeCell) {
      console.log("Updating cell:", storeCell);
      storeCell.textContent = inventoryQuantity;

      storeCell.classList.toggle('highlighted', inventoryQuantity < 6 || inventoryQuantity >= 95);

      // Update or remove alerts
      updateAlerts(storeName, modelName, inventoryQuantity);

      console.log("Cell updated:", storeCell);
    } else {
      console.warn("Store cell not found in row:", storeName);
    }
  } else if (!modelRow) {
    console.warn("Model row not found:", modelName);
  } else if (storeIndex < 0) {
    console.warn("Store column not found:", storeName);
  }
}

function updateAlerts(storeName, modelName, inventoryQuantity) {
  const alertsContainer = document.getElementById('alerts');
  let alertExists = false;

  // Check if an alert already exists for this store and model
  const alertItems = alertsContainer.getElementsByTagName('li');
  for (let item of alertItems) {
    if (item.textContent.includes(`Store: ${storeName}`) && item.textContent.includes(`Model: ${modelName}`)) {
      alertExists = true;
      // Remove alert if inventory is no longer problematic
      if (inventoryQuantity >= 6 && inventoryQuantity < 95) {
        item.remove();
      }
      break;
    }
  }

  // Add new alert if necessary
  if (!alertExists) {
    const alertsList = alertsContainer.querySelector('ul');
    let alertMessage = '';
    if (inventoryQuantity < 6) {
      alertMessage = `<li><strong>Store:</strong> ${storeName} | <strong>Model:</strong> ${modelName} | <strong>Message:</strong> Inventory is too low</li>`;
    } else if (inventoryQuantity >= 95) {
      alertMessage = `<li><strong>Store:</strong> ${storeName} | <strong>Model:</strong> ${modelName} | <strong>Message:</strong> Inventory is too high</li>`;
    }

    if (alertMessage) {
      // Append the new alert message to the end of the list
      alertsList.insertAdjacentHTML('beforeend', alertMessage);
    }
  }
}
