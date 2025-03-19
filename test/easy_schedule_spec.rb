require_relative '../lib/easy_schedule'

describe 'Add a subject to the schedule' do
  it "say hi" do
    result = EasySchedule.hi

    expect(result).to eq('Hello World')  
  end
end