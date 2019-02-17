require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :position_id => 1,
      :realname => "MyString",
      :mobile => "MyString",
      :nickname => "MyString",
      :avatar => "MyString",
      :password_digest => "MyString",
      :job => "MyString",
      :exdata => "MyText",
      :last_sign_in_ip => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input[name=?]", "user[position_id]"

      assert_select "input[name=?]", "user[realname]"

      assert_select "input[name=?]", "user[mobile]"

      assert_select "input[name=?]", "user[nickname]"

      assert_select "input[name=?]", "user[avatar]"

      assert_select "input[name=?]", "user[password_digest]"

      assert_select "input[name=?]", "user[job]"

      assert_select "textarea[name=?]", "user[exdata]"

      assert_select "input[name=?]", "user[last_sign_in_ip]"
    end
  end
end
