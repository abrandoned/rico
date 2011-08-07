module Rico
  module Base
    def clear
      opts = {:op => :clear}
  
      ping(@ping_protect) do
        response = _rico_header(opts)
        _success_response(response, opts)
      end
    end  
  
    def contains_key(key, opts={})
      opts = {:ping => @ping_protect, :raw => false}.merge!(opts).merge!({:op => :contains_key}) 
      
      ping(opts[:ping]) do
        response = _rico_get(key, opts)
        _success_response(response, opts) 
      end
    end
    
    def contains_key?(key, opts={})
      contains_key(key, opts)
    end   
  
    def get(key, opts={})
      opts = {:ping => @ping_protect, :raw => false}.merge!(opts).merge!({:op => :get}) 
      
      ping(opts[:ping]) do
        response = _rico_get(key, opts)
        _data_response(response, opts) 
      end
    end  
  
    def get_with_version(key, opts={})
      opts = {:ping => @ping_protect, :raw => false}.merge!(opts).merge!({:op => :get_with_version}) 
      
      ping(opts[:ping]) do
        response = _rico_get(key, opts)
        _data_response(response, opts) 
      end
    end  
     
    def ping(run_ping=true)
      if run_ping
        response = _rico_header({:op => :ping})
        success = _success_response(response, {:op => :ping})
      end
        
      if (success || !run_ping) && block_given?
        success = yield
      end
      
      return success
    end
      
    def put(key, obj, opts={})
      opts = {:ping => @ping_protect, :raw => false, :expires_in => 0, :max_idle => 0}.merge!(opts).merge!({:op => :put})
  
      ping(opts[:ping]) do 
        response = _rico_put(key, obj, opts)
        _success_response(response, opts)
      end
    end
    
    def put_if_absent(key, obj, opts={})
      opts = {:ping => @ping_protect, :raw => false, :expires_in => 0, :max_idle => 0}.merge!(opts).merge!({:op => :put_if_absent})
      
      ping(opts[:ping]) do 
        response = _rico_put(key, obj, opts)
        _success_response(response, opts)
      end
    end
  
    def remove(key, opts={})
      opts = {:ping => @ping_protect, :raw => false}.merge!(opts).merge!({:op => :remove}) 
      
      ping(opts[:ping]) do
        response = _rico_get(key, opts)
        _success_response(response, opts) 
      end
    end
  
    def remove_if_unmodified(key, opts={})
      opts = {:ping => @ping_protect, :raw => false}.merge!(opts).merge!({:op => :remove_if_unmodified})
      
      ping(opts[:ping]) do
        response = _rico_get(key, opts)
        _success_response(response, opts) 
      end
    end
  
    def replace(key, obj, opts={})
      opts = {:ping => @ping_protect, :raw => false, :expires_in => 0, :max_idle => 0}.merge!(opts).merge!({:op => :replace})
      
      ping(opts[:ping]) do
        response = _rico_put(key, obj, opts)
        _success_response(response, opts)
      end
    end
  
    def replace_if_unmodified(key, obj, opts={})
      opts = {:ping => @ping_protect, :raw => false, :expires_in => 0, :max_idle => 0}.merge!(opts).merge!({:op => :replace_if_unmodified})
      
      ping(opts[:ping]) do
        response = _rico_put(key, obj, opts)
        _success_response(response, opts)
      end
    end
  
    def stats(opts={})    
      opts = {:ping => @ping_protect, :raw => false}.merge!(opts).merge!({:op => :stats})
      ping(opts[:ping]) do 
        response = _rico_header(opts)
        _success_response(response, opts)     
      end
    end

    private 
    
    def _data_response(response, opts)
      case 
      when opts[:raw] then
        return response
      when response[:success] && response[:version] then
        return {:version => response[:version], :data => self.class.serializer[:deserialize, response[:data]]}
      when response[:success] then
        return self.class.serializer[:deserialize, response[:data]]
      else
        return false
      end
    end
    
    def _success_response(response, opts)  
      case
      when opts[:raw] || opts[:op] == :stats then
        return response
      else      
        return response[:success]
      end
    end
  end
end