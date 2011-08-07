module Rico
  module Protocol
    STATUS = {
      :no_error => 0x00,
      :not_put_removed_replaced => 0x01,
      :key_does_not_exist => 0x02,
      :invalid_magic_msg_id => 0x81,
      :unknown_command => 0x82,
      :unknown_version => 0x83,
      :request_parse_error => 0x84,
      :server_error => 0x85,
      :timeout => 0x86
    }
    
    MSG_STATUS = {
      0x00 => false,
      0x01 => false,
      0x02 => false,
      0x81 => true,
      0x82 => true,
      0x83 => true,
      0x84 => true,
      0x85 => true,
      0x86 => true
    }
  end
end
