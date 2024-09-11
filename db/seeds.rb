# Clear existing data
Inventory.destroy_all
Store.destroy_all
ShoeModel.destroy_all

# Store and shoe model data
STORE_STORES = [ 'ALDO Centre Eaton', 'ALDO Destiny USA Mall', 'ALDO Pheasant Lane Mall', 'ALDO Holyoke Mall', 'ALDO Maine Mall', 'ALDO Crossgates Mall', 'ALDO Burlington Mall', 'ALDO Solomon Pond Mall', 'ALDO Auburn Mall', 'ALDO Waterloo Premium Outlets' ]
SHOES_MODELS = [ 'ADERI', 'MIRIRA', 'CAELAN', 'BUTAUD', 'SCHOOLER', 'SODANO', 'MCTYRE', 'CADAUDIA', 'RASIEN', 'WUMA', 'GRELIDIEN', 'CADEVEN', 'SEVIDE', 'ELOILLAN', 'BEODA', 'VENDOGNUS', 'ABOEN', 'ALALIWEN', 'GREG', 'BOZZA' ]

# Create stores
STORE_STORES.each do |store_name|
  Store.create!(name: store_name)
end

# Create shoe models
SHOES_MODELS.each do |model_name|
  ShoeModel.create!(name: model_name)
end

# Create random inventory entries for each store/model combination
STORE_STORES.each do |store_name|
  store = Store.find_by(name: store_name)

  SHOES_MODELS.each do |model_name|
    shoe_model = ShoeModel.find_by(name: model_name)

    # Assign a random quantity between 0 and 100 for demonstration
    Inventory.create!(
      store: store,
      shoe_model: shoe_model,
      quantity: rand(0..70) + 10
    )
  end
end

puts "Seeding completed with stores, shoe models, and random inventory data!"
