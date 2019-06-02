require 'sinatra'
require 'sinatra/json'
require 'venice'

get '/' do
  "Please send a 64 base encoded receipt file to POST '/'"  
end

post '/' do
  begin
    request_payload = JSON.parse request.body.read
  rescue JSON::ParserError
    status 400
    return json({ message: 'please supply a valid json'})
  end

  unless request_payload.key? 'receipt'
    status 400
    return json({ message: "please supply a receipt data, param: 'receipt'"})
  end

  receipt_data = request_payload['receipt']

  if receipt = Venice::Receipt.verify(receipt_data)
    original_build_number = receipt.original_application_version.to_i

    if original_build_number <= 42
      # provide premium feature if build number is smaller than the free with IAP build
    end

    return json({ message: "original_application_version (build number) is #{original_build_number}"})
  else
    status 400
    return json({ message: 'please supply a valid receipt'})
  end
end
