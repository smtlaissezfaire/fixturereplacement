# 
# describe "create_user with attr_protected attributes" do
#   include FixtureReplacement
#   
#   before :each do
#     FixtureReplacement.module_eval do
#       def admin_attributes
#         {
#           :admin_status => true,
#           :name => "Scott"
#         }
#       end
#     end
# 
#     @generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "admin"})
#     @generator.generate_create_method
#   end
# 
#   it "should not complain when an apparent mass assignment has happened with default values" do
#     lambda {
#       create_admin
#     }.should_not raise_error
#   end
# 
#   it "should have admin_status equal to the default value (when it has not been overwritten)" do
#     create_admin.admin_status.should == true
#   end
# 
#   it "should have admin_status equal to the overwritten value" do
#     create_admin(:admin_status => false).admin_status.should be_false
#   end
# 
#   it "should have the other attributes assigned when the attr_value has been overwritten" do
#     create_admin(:admin_status => false).name.should == "Scott"
#   end
# 
#   it "should have the other attributes assigned even when the attr_value has not been overwritten" do
#     create_admin.name.should == "Scott"
#   end    
# end
# 
# describe "new_user with attr_protected attributes" do
#   include FixtureReplacement
#   
#   before :each do
#     FixtureReplacement.module_eval do
#       def admin_attributes
#         {
#           :admin_status => true,
#           :name => "Scott"
#         }
#       end
#     end
# 
#     @generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "admin"})
#     @generator.generate_new_method
#   end
# 
#   it "should have admin_status equal to the default value (when it has not been overwritten)" do
#     new_admin.admin_status.should == true
#   end
# 
#   it "should have admin_status equal to the overwritten value" do
#     new_admin(:admin_status => false).admin_status.should be_false
#   end
# 
#   it "should have the other attributes assigned when the attr_value has been overwritten" do
#     new_admin(:admin_status => false).name.should == "Scott"
#   end
# 
#   it "should have the other attributes assigned even when the attr_value has not been overwritten" do
#     new_admin.name.should == "Scott"
#   end    
# end  
# 
# 
