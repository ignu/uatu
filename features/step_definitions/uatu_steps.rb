Given /^my current user is "([^"]*)"$/ do |current_user|
  $current_user = current_user
  Uatu.current_user.should == current_user
end

When /^I create a new Ninja with name "([^"]*)"$/ do |name|
  ninja = Ninja.new (:name => name )
  ninja.save
end

Then /^I should see the following logs:$/ do |table|

end
