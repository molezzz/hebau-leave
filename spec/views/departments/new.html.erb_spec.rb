require 'rails_helper'

RSpec.describe "departments/new", type: :view do
  before(:each) do
    assign(:department, Department.new(
      :parent_id => 1,
      :name => "MyString",
      :category_id => 1
    ))
  end

  it "renders new department form" do
    render

    assert_select "form[action=?][method=?]", departments_path, "post" do

      assert_select "input[name=?]", "department[parent_id]"

      assert_select "input[name=?]", "department[name]"

      assert_select "input[name=?]", "department[category_id]"
    end
  end
end
