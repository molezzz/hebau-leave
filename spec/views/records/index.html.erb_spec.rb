require 'rails_helper'

RSpec.describe "records/index", type: :view do
  before(:each) do
    assign(:records, [
      Record.create!(
        :user_id => 2,
        :approver_id => 3,
        :status => 4,
        :address => "Address",
        :tel => "Tel",
        :cause => "MyText",
        :agent => "Agent",
        :agent_office => "Agent Office",
        :agent_office_tel => "Agent Office Tel",
        :agent_mobile => "Agent Mobile",
        :exdata => "MyText"
      ),
      Record.create!(
        :user_id => 2,
        :approver_id => 3,
        :status => 4,
        :address => "Address",
        :tel => "Tel",
        :cause => "MyText",
        :agent => "Agent",
        :agent_office => "Agent Office",
        :agent_office_tel => "Agent Office Tel",
        :agent_mobile => "Agent Mobile",
        :exdata => "MyText"
      )
    ])
  end

  it "renders a list of records" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Tel".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Agent".to_s, :count => 2
    assert_select "tr>td", :text => "Agent Office".to_s, :count => 2
    assert_select "tr>td", :text => "Agent Office Tel".to_s, :count => 2
    assert_select "tr>td", :text => "Agent Mobile".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
