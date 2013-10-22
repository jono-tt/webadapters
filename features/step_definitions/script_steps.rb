Given /the simple site/ do
  @simple_site = FactoryGirl.create(:site, :name => "Simple Site")
end

Given /the simple api method called "(.*)" with script "(.*)"/ do |api_name, script_name|
  script = File.read(File.join(Rails.root, "features", "scripts", script_name))
  api_method = FactoryGirl.create(:api_method, :site => @simple_site, :name => api_name, :script => script)
end

Given /^the origin site "(.*)" returns the page "(.*)"$/ do |url, fixture|
  body = File.read(File.join(Rails.root, "features", "fixtures", fixture))
  stub_request(:any, url).to_return(:body => body, :status => 200, :content_type => "text/html", :headers => { 'Content-Type' => 'text/html; charset=UTF-8'})
end

Given /that posting to the origin site "(.*)" returns the page "(.*)" for data$/ do |url, fixture, post_data_table|
  body = File.read(File.join(Rails.root, "features", "fixtures", fixture))

  stub_request(:post, url).
    with(:body => post_data_table.rows_hash).
    to_return(:body => body, :status => 200, :content_type => "text/html", :headers => { 'Content-Type' => 'text/html; charset=UTF-8'})
end

Given /the "(.*)" site exists/ do |name|
  underscore_name = name.gsub(' ', '_')
  step %{the simple site}
  step %{the simple api method called "#{underscore_name}" with script "#{underscore_name}"}
end

Given /^the api method "(.*)" with (\d+) versions$/ do |name, version_count|
  step %{the simple site}

  user = FactoryGirl.create(:user)
  api_method = FactoryGirl.create(:api_method, :site => @simple_site, :name => name, :script => "initial script")
  (version_count.to_i - 1).times do |count|
    api_method.script = %{"script change #{count + 1}"}
    api_method.save_version(:message => "change #{count + 1}", :user => user)
  end
end


When /^I go to the api method "(.*) - (.*)"$/ do |site_name, api_method_name|
  visit("/")
  click_link site_name
  click_link api_method_name
end

When /^I run the script for (.*)$/ do |api_method|
  step %{I go to the api method #{api_method}}
  click_button "Run"
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end

When /^I view the versions for (.*)$/ do |api_method|
  step %{I go to the api method #{api_method}}
  click_link "Versions"
end

When /^I select the version "(.*)"$/ do |version|
  select version, :from => 'Select a version'
end

When /^I select the comparison "(.*)"$/ do |version|
  select version, :from => 'Compare with version'
end

When /^I save the script for (.*)$/ do |api_method|
  step %{I go to the api method #{api_method}}
  click_button("start-save-script")
  find("#save-script-controls").fill_in('commit-message', :with => "A commit message")
  click_button("save-script")
end

When /^I restore version "(.*)" for (.*)$/ do |version, api|
  step %{I view the versions for #{api}}
  select version, :from => 'Select a version'
  click_button("Restore this version")
end



Then /^I see the result '(.*?)'$/ do |result|
  find("#result").text.should == result
end

Then /^I see the error message '(.*)'$/ do |error|
  find(".script-error").text.should match(error)
end

Then /^I see the warning message '(.*)'$/ do |warning|
  find(".script-warning").text.should match(warning)
end

Then /^I see debug information "(.*?)"$/ do |debug_info|
  find("#debug li").text.should match(debug_info)
end

Then /^I see the result "(.*?)"$/ do |msg|
  page.should have_content(msg)
end

Then /^I see '"(.*)"' in the editor$/ do |script|
  find("#editor").text.should match(script)
end

Then /^I see the script '(.*)'$/ do |script|
  find("#script").text.should match(script)
end

Then /^I see the diff '(.*)'$/ do |diff|
  page.html.should match(/<pre id="diff">\s*#{diff}\s*<\/pre>/m)
end

Then /^I see stats for it$/ do
  page.find("#stats li:first strong").text.should == "total:"
end
