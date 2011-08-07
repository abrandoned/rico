module Rico
  module RequestHeader
    def header(opts={})
      opts = { :flag => opts[:put_ret] ? :put_ret : :none, 
               :cache => [], 
               :id => Time.now.usec, 
               :op => :ping,
               :top_id => 0,
               :intelligence => Protocol::CLIENT_INTELLIGENCE[:basic] }.merge!(opts)
    
      header = []
      header << Protocol::MAGIC[:request].chr <<  # "Magic" byte
                VLong.encode(opts[:id]) <<  # Message Id
                Protocol::VERSION.chr << # currently 10
                Protocol::REQUEST[opts[:op]].chr << # runs a ping by default
                VInt.encode(opts[:cache].length) <<   # determine the length of the requested cache
                opts[:cache] <<  # defaults to the default cache
                VInt.encode(Protocol::FLAG[opts[:flag]]) << # Flag bitmask
                opts[:intelligence].chr << # currently only supporting basic 
                VInt.encode(opts[:top_id]) << # basic client only needs 0
                Protocol::XA_TYPE[:none].chr # tranactions currently unsupported
    end
  end
end