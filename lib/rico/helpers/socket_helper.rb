require 'socket'

module Rico
  module SocketHelper
    class << self
      # Method that helps determine the socketpool connection type for the topology returned
      def socket_type(host, port)
        sock_type = Socket::getaddrinfo(host, port, nil, Socket::SOCK_STREAM).flatten.first
        case sock_type
        when "AF_INET" then
          return :tcp
        when "AF_INET6" then
          return :tcp6
        else
          raise Rico::RicoError.new, "Unsupported socket type: #{sock_type}"
        end
      end
    end
  end
end