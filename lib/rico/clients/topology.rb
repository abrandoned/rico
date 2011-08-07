module Rico
  class Topology
    include Rico::RequestHeader
    include Rico::ResponseParser
    include Rico::Base

    class << self
      def serializer
        return Rico::Serialization
      end
    end
  
    def initialize(opts={}) 
      @connection_opts = {:host => "127.0.0.1", :port => 11222, :ping_protect => false}.merge!(opts)
      @ping_protect = @connection_opts[:ping_protect]
      @topology_id = 0
    end 

    private

    def conn
      begin
        @socketpool ||= SocketPool.new(@connection_opts[:host], 
                                       @connection_opts[:port], 
                                       :type => Rico::SocketHelper.socket_type(@connection_opts[:host], @connection_opts[:port]), 
                                       :size => 3, :eager => true)
        socket = @socketpool.checkout
        yield(socket)
      ensure
        @socket_clear = false if !defined?(@socket_clear)
        socket.flush
        @socketpool.checkin(socket, @socket_clear)
      end
    end

    def _rico_get(key, opts)
      opts = opts.merge!({:intelligence => Protocol::CLIENT_INTELLIGENCE[:topology], :top_id => @topology_id})
      key_bytes = self.class.serializer[:serialize, key]
      response = {}
      
      conn do |c|
        c.write(header(opts) << VInt.encode(key_bytes.length) << key_bytes << (opts[:version] || []))
        c.flush
        response.merge!(parse_response(c, opts))
      end
      
      return response
    end

    def _rico_header(opts)
      opts = opts.merge!({:intelligence => Protocol::CLIENT_INTELLIGENCE[:topology], :top_id => @topology_id})
      response = {}
      
      conn do |c|
        c.write(header(opts))
        c.flush
        response.merge!(parse_response(c, opts))
      end
      
      return response
    end  
  
    def _rico_put(key, obj, opts)
      opts = {:put_ret => false}.merge!(opts).merge!({:intelligence => Protocol::CLIENT_INTELLIGENCE[:topology], :top_id => @topology_id})
      key_bytes = self.class.serializer[:serialize, key]
      obj_bytes = self.class.serializer[:serialize, obj]
      response = {}
      
      conn do |c|
        c.write(header(opts) <<
            VInt.encode(key_bytes.length) << key_bytes << 
            VInt.encode(opts[:expires_in]) << VInt.encode(opts[:max_idle]) << 
            (opts[:version] || []) << VInt.encode(obj_bytes.length) << obj_bytes)
        c.flush    
        response.merge!(parse_response(c, opts))        
      end
      
      return response
    end 
  end
end