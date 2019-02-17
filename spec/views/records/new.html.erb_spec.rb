require 'rails_helper'

RSpec.describe "records/new", type: :view do
  before(:each) do
    assign(:record, Record.new(
      :user_id => 1,
      :approver_id => 1,
      :status => 1,
      :address => "MyString",
      :tel => "MyString",
      :cause => "MyText",
      :agent => "MyString",
      :agent_office => "MyString",
      :agent_office_tel => "MyString",
      :agent_mobile => "MyString",
      :exdata => "MyText"
    ))
  end

  it "renders new record form" do
    render

    assert_select "form[action=?][method=?]", records_path, "post" do

      assert_select "input[name=?]", "record[user_id]"

      assert_select "input[name=?]", "record[approver_id]"

      assert_select "input[name=?]", "record[status]"

      assert_select "input[name=?]", "record[address]"

      assert_select "input[name=?]", "record[tel]"

      assert_select "textarea[name=?]", "record[cause]"

      assert_select "input[name=?]", "record[agent]"

      assert_select "input[name=?]", "record[agent_office]"

      assert_select "input[name=?]", "record[agent_office_tel]"

      assert_select "input[name=?]", "record[agent_mobile]"

      assert_select "textarea[name=?]", "record[exdata]"
    end
  end
end
