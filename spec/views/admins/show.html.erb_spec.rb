require 'rails_helper'

RSpec.describe "admins/show", type: :view do
  before(:each) do
    @admin = assign(:admin, Admin.create!(
      :username => "Username",
      :password_digest => "Password Digest",
      :last_sign_in_ip => "Last Sign In Ip",
      :roles => "Roles"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Username/)
    expect(rendered).to match(/Password Digest/)
    expect(rendered).to match(/Last Sign In Ip/)
    expect(rendered).to match(/Roles/)
  end
end
