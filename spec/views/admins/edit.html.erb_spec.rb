require 'rails_helper'

RSpec.describe "admins/edit", type: :view do
  before(:each) do
    @admin = assign(:admin, Admin.create!(
      :username => "MyString",
      :password_digest => "MyString",
      :last_sign_in_ip => "MyString",
      :roles => "MyString"
    ))
  end

  it "renders the edit admin form" do
    render

    assert_select "form[action=?][method=?]", admin_path(@admin), "post" do

      assert_select "input[name=?]", "admin[username]"

      assert_select "input[name=?]", "admin[password_digest]"

      assert_select "input[name=?]", "admin[last_sign_in_ip]"

      assert_select "input[name=?]", "admin[roles]"
    end
  end
end
