require 'spec_helper'

describe RedisRpc do

  it "should have a logger" do
    RedisRpc.logger.wont_equal nil
  end

  it "should support random_id" do
    RedisRpc.random_id.wont_equal nil
  end

  describe "when using a given random source" do

    class FakeRandomSource
      def random_bytes(l)
        'x' * l
      end
    end

    before do
      RedisRpc.random_source = FakeRandomSource.new
    end

    it "should use the given random source" do
      RedisRpc.random_id.must_equal(
        "7878787878787878787878787878787878787878787878787878787878787878"
      )
    end

    after do
      RedisRpc.random_source = nil
    end
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

      unpacked = MessagePack.unpack(packed)
      unpacked["first_name"].must_equal o.first_name
      unpacked["last_name"].must_equal o.last_name
    end

  end

end
