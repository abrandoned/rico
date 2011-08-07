module Rico
  module Protocol    
    MAGIC = {
      :request => 0xA0,
      :response => 0xA1
    }
    
    VERSION = 10   
    
    CLIENT_INTELLIGENCE = {
      :basic => 0x01,  # Basic client is not interested in topology or hash changes
      :topology => 0x02,  # Topology will be sent changes in topology from server (i.e. add nodes )
      :hash_dist => 0x03  # Hash Dist is niterested in topology changes and hash info
    }
    
    TOPOLOGY_CHANGE = {
      0 => false,
      1 => true
    }
    
    XA_TYPE = {
      :none => 0x00,
      :x_open => 0x01
    }
    
    FLAG = {
      :none => 0x00,
      :put_ret => 0x01
    }
  end
end
