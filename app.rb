require 'sinatra'
require 'sinatra/json'

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
    return json({ message: "original_application_version (build number) is #{receipt.original_application_version.to_i}"})
  else
    status 400
    return json({ message: 'please supply a valid receipt'})
  end
end
