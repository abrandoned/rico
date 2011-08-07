class VInt
  class << self
    def encode(val)
      ret = []
      case 
      when val < 128 # 2**7
        ret[0] = val.chr
      when val < 16384 # 2**14
        ret[0] = (128 | val >> 7).chr
        ret[1] = (val & 127).chr
      when val < 2097152 # 2**21
        ret[0] = (128 | val >> 14).chr
        ret[1] = (128 | val >> 7 & 127).chr
        ret[2] = (val & 127).chr
      when val < 268435456 # 2**28
        ret[0] = (128 | val >> 21).chr
        ret[1] = (128 | val >> 14 & 127).chr
        ret[2] = (128 | val >> 7 & 127).chr
        ret[3] = (val & 127).chr
      when val < 34359738368 # 2**35
        ret[0] = (128 | val >> 28).chr
        ret[1] = (128 | val >> 21 & 127).chr
        ret[2] = (128 | val >> 14 & 127).chr
        ret[3] = (128 | val >> 7 & 127).chr
        ret[4] = (val & 127).chr
      else
        raise "Invalid VInt [encode]"
      end
      
      return ret
    end
    
    def decode(input)
      byte = input.getbyte
      ret = 0
      while byte >= 128 do
        ret = (ret << 7) + (byte & 127)
        byte = input.getbyte
      end
      ret = (ret << 7) + (byte & 127)
      return ret 
    end
  end
end
