require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :position_id => 2,
        :realname => "Realname",
        :mobile => "Mobile",
        :nickname => "Nickname",
        :avatar => "Avatar",
        :password_digest => "Password Digest",
        :job => "Job",
        :exdata => "MyText",
        :last_sign_in_ip => "Last Sign In Ip"
      ),
      User.create!(
        :position_id => 2,
        :realname => "Realname",
        :mobile => "Mobile",
        :nickname => "Nickname",
        :avatar => "Avatar",
        :password_digest => "Password Digest",
        :job => "Job",
        :exdata => "MyText",
        :last_sign_in_ip => "Last Sign In Ip"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Realname".to_s, :count => 2
    assert_select "tr>td", :text => "Mobile".to_s, :count => 2
    assert_select "tr>td", :text => "Nickname".to_s, :count => 2
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
    assert_select "tr>td", :text => "Password Digest".to_s, :count => 2
    assert_select "tr>td", :text => "Job".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Last Sign In Ip".to_s, :count => 2
  end
end
