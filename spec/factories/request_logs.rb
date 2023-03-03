# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :request_log do
    uuid { SecureRandom.uuid }
    uri { "http://localhost:3000/auth/sign-in" }
    remote_address { IPAddr.new("0.0.0.0") }
    session_id { "0c88069a83b889498e1858a8b28f31d7" }
    session_private_id { "2::b6f320c19f29c590ef87ff0af3fe6bc7b3562552ad18ae3e87879a08276aac83" }
    ip_info { {"ip"=>"0.0.0.0", "bogon"=>true, "ip_address"=>"0.0.0.0"} }
    is_xhr { false }
  end
end
