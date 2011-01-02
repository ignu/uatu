Given /^my current user is "([^"]*)"$/ do |current_user|
  $current_user = current_user
  Uatu.current_user.should == current_user
end

When /^I create a new ([^"]*) with name "([^"]*)"( and weapon "([^"]*)")?$/ do |klass, name, full_weapon, weapon|
  entity = Kernel.const_get(klass).new(:name => name )
  entity.weapon = weapon unless weapon.nil?
  entity.save
  entity.reload
end

def get_clan(entity)
  Clan.where(:name => entity).first
end

def get_audit_logs(type, entity)
  return AuditLog.all.to_a if type.nil?
  return audit_logs = AuditLog.for_entity(Ninja.where(:name => entity).first) if type == "ninja"
  return audit_logs = AuditLog.for_entity(get_clan(entity)) if type == "clan"
  AuditLog.for_user entity
end

Then /^I should see the following logs( for (ninja|user|clan) "([^"]*)")?:$/ do |full_user, type, entity, table|
  audit_logs = get_audit_logs(type, entity)

  raise "not enough audit logs were returned, only #{audit_logs.length}" unless audit_logs.length >= table.hashes.length
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

When /^I add "([^"]*)" to "([^"]*)"$/ do |ninja_name, clan_name|
  clan = Clan.where(:name => clan_name).first
  ninja = Ninja.new :name => ninja_name
  clan.ninjas << ninja
end
