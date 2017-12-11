remote_broker_uri = Rails.application.config.acapi.remote_broker_uri
environment_name = 'prod'
target_exchange = "ma0.#{environment_name}.e.fanout.events"
effective_on_date = "2018-01-01"
event_routing_key = "info.events.employer.renewal_transmission_authorized"

renewing_employer_feins = %w(

)

conn = Bunny.new(remote_broker_uri, :heartbeat => 15)
conn.start
chan = conn.create_channel
chan.confirm_select
ex = chan.fanout(target_exchange, :durable => true) 
renewing_employer_feins.each do |fein|
 ex.publish(
   "",
   {
     :routing_key => event_routing_key,
     :headers => {
       "fein" => fein.strip,
       "effective_on" => effective_on_date
     }
   }
 )
 chan.wait_for_confirms
end
conn.close

