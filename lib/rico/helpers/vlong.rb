require 'rico/helpers/vint'

class VLong
  class << self  
    def encode(val)
      ret = []
      case 
      when val < 34359738368 # 2**35
        ret = VInt.encode(val)
      when val < 4398046511104 # 2**42
        ret[0] = (128 | val >> 35).chr
        ret[1] = (128 | val >> 28 & 127).chr
        ret[2] = (128 | val >> 21 & 127).chr
        ret[3] = (128 | val >> 14 & 127).chr
        ret[4] = (128 | val >> 7 & 127).chr
        ret[5] = (val & 127).chr
      when val < 562949953421312 # 2**49
        ret[0] = (128 | val >> 42).chr
        ret[1] = (128 | val >> 35 & 127).chr
        ret[2] = (128 | val >> 28 & 127).chr
        ret[3] = (128 | val >> 21 & 127).chr
        ret[4] = (128 | val >> 14 & 127).chr
        ret[5] = (128 | val >> 7 & 127).chr
        ret[6] = (val & 127).chr
      when val < 72057594037927936 # 2**56
        ret[0] = (128 | val >> 49).chr
        ret[1] = (128 | val >> 42 & 127).chr
        ret[2] = (128 | val >> 35 & 127).chr
        ret[3] = (128 | val >> 28 & 127).chr
        ret[4] = (128 | val >> 21 & 127).chr
        ret[5] = (128 | val >> 14 & 127).chr
        ret[6] = (128 | val >> 7 & 127).chr
        ret[7] = (val & 127).chr
      when val < 9223372036854775808 # 2**63
        ret[0] = (128 | val >> 56).chr
        ret[1] = (128 | val >> 49 & 127).chr
        ret[2] = (128 | val >> 42 & 127).chr
        ret[3] = (128 | val >> 35 & 127).chr
        ret[4] = (128 | val >> 28 & 127).chr
        ret[5] = (128 | val >> 21 & 127).chr
        ret[6] = (128 | val >> 14 & 127).chr
        ret[7] = (128 | val >> 7 & 127).chr
        ret[8] = (val & 127).chr      
      else
        raise "Invalid VLong [encode]"
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
