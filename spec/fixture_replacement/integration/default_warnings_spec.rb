require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "default_* warnings" do
  before do
    @mod = use_module do
      attributes_for :post

      attributes_for :comment
    end
  end

  it "should warn when using default_" do
    Kernel.should_receive(:warn).with("default_post has been deprecated. Please replace instances of default_post with the new_post method")
    @mod.default_post
  end

  it "should use the correct builder name" do
    Kernel.should_receive(:warn).with("default_comment has been deprecated. Please replace instances of default_comment with the new_comment method")
    @mod.default_comment
  end

  it "should return a new instance" do
    Kernel.stub!(:warn).and_return nil

    post = @mod.default_post
    post.should be_a_kind_of(Post)
    post.should be_a_new_record
  end
end
