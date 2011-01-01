
Given /^my current user is "([^"]*)"$/ do |current_user|
  $current_user = current_user
  Uatu.current_user.should == current_user
end

When /^I create a new Ninja with name "([^"]*)"( and weapon "([^"]*)")?$/ do |name, full_weapon, weapon|
  ninja = Ninja.new (:name => name )
  ninja.weapon = weapon unless weapon.nil?
  ninja.save
  ninja.reload
end

Then /^I should see the following logs( for "([^"]*)")?:$/ do |full_user, user, table|
  audit_logs = AuditLog.all.to_a
  table.hashes.each_with_index do |response_hash,index|
    audit_logs[index].entity_type.should == response_hash["type"]
    audit_logs[index].action.should      == response_hash["action"]
    audit_logs[index].user.should        == response_hash["user"]
    audit_logs[index].message.should     == response_hash["message"] unless response_hash["message"].nil?
  end
end

When /^I update Ninja "([^"]*)" with "([^"]*)"$/ do |ninja_name, arguments|
  ninja = Ninja.where(:name => ninja_name).last
  arguments = arguments.split(":")
  ninja.weapon = arguments[1]
  ninja.save
end
