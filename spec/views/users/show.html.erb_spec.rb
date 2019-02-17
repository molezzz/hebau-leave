require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :position_id => 2,
      :realname => "Realname",
      :mobile => "Mobile",
      :nickname => "Nickname",
      :avatar => "Avatar",
      :password_digest => "Password Digest",
      :job => "Job",
      :exdata => "MyText",
      :last_sign_in_ip => "Last Sign In Ip"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Realname/)
    expect(rendered).to match(/Mobile/)
    expect(rendered).to match(/Nickname/)
    expect(rendered).to match(/Avatar/)
    expect(rendered).to match(/Password Digest/)
    expect(rendered).to match(/Job/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Last Sign In Ip/)
  end
end
