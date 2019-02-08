require 'rails_helper'

RSpec.describe "departments/index", type: :view do
  before(:each) do
    assign(:departments, [
      Department.create!(
        :parent_id => 2,
        :name => "Name",
        :category_id => 3
      ),
      Department.create!(
        :parent_id => 2,
        :name => "Name",
        :category_id => 3
      )
    ])
  end

  it "renders a list of departments" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
