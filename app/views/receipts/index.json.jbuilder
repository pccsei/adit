json.array!(@receipts) do |receipt|
  json.extract! receipt, 
  json.url receipt_url(receipt, format: :json)
end
