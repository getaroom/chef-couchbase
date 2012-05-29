require "spec_helper"
require "bucket_resource"

describe Chef::Resource::CouchbaseBucket do
  describe ".ancestors" do
    it { described_class.ancestors.should include Chef::Resource }
  end

  describe "#action" do

  end
end

# {
#     "errors":
#     {
#         "replicaNumber":"The replica number must be specified and must be a non-negative integer.",
#         "ramQuotaMB":"The RAM Quota must be specifed and must be a positive integer."
#     },
# }
