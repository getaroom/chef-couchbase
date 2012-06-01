shared_examples_for "a no op provider action" do
  it "does not POST to the Management REST API" do
    subject
    a_request(:post, /.*/).should_not have_been_made
  end

  it "does not update the new resource" do
    new_resource.should_not_receive(:updated_by_last_action)
    subject
  end

  it "does not log" do
    Chef::Log.should_not_receive(:info)
    subject
  end
end
