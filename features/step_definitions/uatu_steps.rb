
Given /^my current user is "([^"]*)"$/ do |current_user|
  $current_user = current_user
  Uatu.current_user.should == current_user
end

When /^I create a new Ninja with name "([^"]*)"( and weapon "([^"]*)")?$/ do |name, full_weapon, weapon|
  ninja = Ninja.new (:name => name )
  ninja.send(:weapon=, weapon) unless weapon.nil?
  ninja.save
end

Then /^I should see the following logs:$/ do |table|
  audit_logs = AuditLog.all.to_a
  table.hashes.each_with_index do |response_hash,index|
    audit_logs[index].entity_type.should == response_hash["type"]
    audit_logs[index].action.should      == response_hash["action"]
    audit_logs[index].user.should        == response_hash["user"]
  end
end

When /^I update Ninja "([^"]*)" with "([^"]*)"$/ do |ninja_name, arguments|
  ninja = Ninja.where(:name => ninja_name).first
  arguments = arguments.split(":")
  ninja.send(arguments[0], arguments[1])
  ninja.save
end
