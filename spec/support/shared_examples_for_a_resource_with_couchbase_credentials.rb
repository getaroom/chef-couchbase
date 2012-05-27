shared_examples_for "a resource with couchbase credentials" do
  describe "#password" do
    it "can be assigned" do
      resource.password "password"
      resource.password.should == "password"
    end

    it "cannot be assigned an Integer" do
      expect { resource.password 42 }.to raise_error Chef::Exceptions::ValidationFailed
    end
  end

  describe "#username" do
    it "can be assigned" do
      resource.username "myuser"
      resource.username.should == "myuser"
    end

    it "cannot be assigned an Integer" do
      expect { resource.username 42 }.to raise_error Chef::Exceptions::ValidationFailed
    end

    it "defaults to Administrator" do
      resource.username.should == "Administrator"
    end
  end
end
