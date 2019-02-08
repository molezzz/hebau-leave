require 'rails_helper'

RSpec.describe "departments/edit", type: :view do
  before(:each) do
    @department = assign(:department, Department.create!(
      :parent_id => 1,
      :name => "MyString",
      :category_id => 1
    ))
  end

  it "renders the edit department form" do
    render

    assert_select "form[action=?][method=?]", department_path(@department), "post" do

      assert_select "input[name=?]", "department[parent_id]"

      assert_select "input[name=?]", "department[name]"

      assert_select "input[name=?]", "department[category_id]"
    end
  end
end
