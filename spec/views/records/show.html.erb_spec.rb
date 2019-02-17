require 'rails_helper'

RSpec.describe "records/show", type: :view do
  before(:each) do
    @record = assign(:record, Record.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Tel/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Agent/)
    expect(rendered).to match(/Agent Office/)
    expect(rendered).to match(/Agent Office Tel/)
    expect(rendered).to match(/Agent Mobile/)
    expect(rendered).to match(/MyText/)
  end
end
