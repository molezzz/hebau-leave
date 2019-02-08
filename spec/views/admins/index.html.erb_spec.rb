require 'rails_helper'

RSpec.describe "admins/index", type: :view do
  before(:each) do
    assign(:admins, [
      Admin.create!(
        :username => "Username",
        :password_digest => "Password Digest",
        :last_sign_in_ip => "Last Sign In Ip",
        :roles => "Roles"
      ),
      Admin.create!(
        :username => "Username",
        :password_digest => "Password Digest",
        :last_sign_in_ip => "Last Sign In Ip",
        :roles => "Roles"
      )
    ])
  end

  it "renders a list of admins" do
    render
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Password Digest".to_s, :count => 2
    assert_select "tr>td", :text => "Last Sign In Ip".to_s, :count => 2
    assert_select "tr>td", :text => "Roles".to_s, :count => 2
  end
end
