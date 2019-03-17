require 'andpush'

class StaticPagesController < ApplicationController
  def index
    server_key   = "..." # Your server key
    device_token = "..." # The device token of the device you'd like to push a message to
    client  = Andpush.new(server_key, pool_size: 25)
    payload = {
        to: device_token,
        notification: {
            title: "Update",
            body: "Your weekly summary is ready"
        },
        data: { extra: "data" }
    }

    response = client.push(payload)

    headers = response.headers
    headers['Retry-After'] # => returns 'Retry-After'

    json = response.json
    json[:canonical_ids] # => 0
    json[:failure]       # => 0
    json[:multicast_id]  # => 8478364278516813477

    result = json[:results].first
    result[:message_id]      # => "0:1489498959348701%3b8aef473b8aef47"
    result[:error]           # => nil, "InvalidRegistration" or something else
    result[:registration_id] # => nil

    render json: json
  end
end
