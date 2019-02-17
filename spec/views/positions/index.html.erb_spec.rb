require 'rails_helper'

RSpec.describe "positions/index", type: :view do
  before(:each) do
    assign(:positions, [
      Position.create!(
        :name => "Name"
      ),
      Position.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of positions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
