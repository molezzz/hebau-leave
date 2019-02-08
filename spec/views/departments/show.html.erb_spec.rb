require 'rails_helper'

RSpec.describe "departments/show", type: :view do
  before(:each) do
    @department = assign(:department, Department.create!(
      :parent_id => 2,
      :name => "Name",
      :category_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/3/)
  end
end
