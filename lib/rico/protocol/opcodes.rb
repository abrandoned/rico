module Rico
  module Protocol
    REQUEST = {
      :put => 0x01,
      :get => 0x03,
      :put_if_absent => 0x05,
      :replace => 0x07,
      :replace_if_unmodified => 0x09,
      :remove => 0x0B,
      :remove_if_unmodified => 0x0D,
      :contains_key => 0x0F,
      :get_with_version => 0x11,
      :clear => 0x13,
      :stats => 0x15,
      :ping => 0x17,
      :bulk_get => 0x19
    }
    
    RESPONSE = {
      :put => 0x02,
      :get => 0x04,
      :put_if_absent => 0x06,
      :replace => 0x08,
      :replace_if_unmodified => 0x0A,
      :remove => 0x0C,
      :remove_if_unmodified => 0x0E,
      :contains_key => 0x10,
      :get_with_version => 0x12,
      :clear => 0x14,
      :stats => 0x16,
      :ping => 0x18,
      :bulk_get => 0x1A,
      :error => 0x50
    }
    
    DATA_RETURN = {
      :put => false,
      :get => true,
      :put_if_absent => false,
      :replace => false,
      :replace_if_unmodified => false,
      :remove => false,
      :remove_if_unmodified => false,
      :contains_key => false,
      :get_with_version => true,
      :clear => false,
      :stats => false,
      :ping => false,
      :bulk_get => true
    }
  end
end