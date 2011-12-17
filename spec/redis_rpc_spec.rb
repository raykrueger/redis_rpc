require 'spec_helper'

describe RedisRpc do

  it "should have a logger" do
    RedisRpc.logger.wont_equal nil
  end

end
