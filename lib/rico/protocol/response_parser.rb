module Rico
  module ResponseParser
    def parse_response(sock, opts={})
      opts = {:op => :ping, :put_ret => false}.merge!(opts)
      
      response = {
        :magic => sock.getbyte,  # Magic response
        :id => VLong.decode(sock),  # Message id
        :opcode => sock.getbyte,  # Opcode
        :status => sock.getbyte, # status
        :topology_change => sock.getbyte,  # topology change marker
        :data_size => 0,
        :data => nil, 
        :clear_socket => false
      }

      response[:success] = (response[:status] == Protocol::STATUS[:no_error])            
      response = parse_topology_changes(sock, opts) if response[:success] && Protocol::TOPOLOGY_CHANGE[response[:topology_change]]
      return parse_op_body(sock, response, opts)
    end

    def parse_topology_changes(sock, response, opts)
      response[:topology] = {}
      response[:topology][:id] = VInt.decode(sock)

      case opts[:intelligence]
      when Protocol::CLIENT_INTELLIGENCE[:topology] then
        response[:topology][:num] = VInt.decode(sock)
        repsonse[:topology][:servers] = []
        response[:topology][:num].times do |num|
          response[:topology][:servers] << {:num => num, :host => sock.read(VInt.decode(sock)), :port => sock.read(2)}
        end
      when Protocol::CLIENT_INTELLIGENCE[:hash] then
        response[:topology][:key_owners] = sock.read(2)
        response[:topology][:hash_version] = sock.read(1)
        response[:topology][:space_size] = VInt.decode(sock)
        response[:topology][:num] = VInt.decode(sock)
        repsonse[:topology][:servers] = []
        response[:topology][:num].times do |num|
          response[:topology][:servers] << {:num => num, 
                                            :host => sock.read(VInt.decode(sock)), 
                                            :port => sock.read(2), 
                                            :hashcode => sock.read(4)}
        end
      else
        raise Rico::RicoError.new, "Uknown CLIENT_INTELLIGENCE: #{opts[:intelligence]}"
      end

      return response
    end
    
    def parse_data_size(sock, opts)
      return 0 if !opts[:put_ret] && !Rico::Protocol::DATA_RETURN[opts[:op]]
      return VInt.decode(sock)
    end

    def parse_op_body(sock, response, opts)
      case
      when response[:success] && opts[:op] == :stats then
        response[:data] = {}
        response[:data_size] = VInt.decode(sock)
        response[:data_size].times do                     
          response[:data][sock.read(VInt.decode(sock))] = sock.read(VLong.decode(sock))
        end
      when response[:success] then
        response[:version] = sock.read(8) if opts[:op] == :get_with_version
        response[:data_size] = parse_data_size(sock, opts)
        response[:data] = sock.read(response[:data_size]) if response[:data_size] > 0
      when !response[:success] && Protocol::MSG_STATUS[response[:status]] then
        response[:clear_socket] = true
        response[:error_message] = sock.read(VLong.decode(sock))
      end

      sock.flush
      return response
    end
  end
end