require 'spec_helper'

describe RedisRpc do

  it "should have a logger" do
    RedisRpc.logger.wont_equal nil
  end

  describe RedisRpc::Packed do

    class TestObject
      include RedisRpc::Packed

      attr_accessor :first_name
      attr_accessor :last_name
    end

    it "should pack all instance vars" do
      o = TestObject.new
      o.first_name = "Ray"
      o.last_name = "Krueger"
      packed = o.to_msgpack

      packed.must_equal "\202\251last_name\247Krueger\252first_name\243Ray" 

      unpacked = MessagePack.unpack(packed)
      unpacked["first_name"].must_equal o.first_name
      unpacked["last_name"].must_equal o.last_name
    end

  end

end
