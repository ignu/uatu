Given /^my current user is "([^"]*)"$/ do |current_user|
  $current_user = current_user
  Uatu.current_user.should == current_user
end

When /^I create a new Ninja with name "([^"]*)"$/ do |name|
  ninja = Ninja.new (:name => name )
  ninja.save
end

Then /^I should see the following logs:$/ do |table|
  audit_logs = AuditLog.all.to_a
  table.hashes.each_with_index do |response_hash,index|
    audit_logs[index].entity_type.should == response_hash["type"]
    audit_logs[index].user.should == response_hash["user"]
  end
end
