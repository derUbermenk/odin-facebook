require "rails_helper"

RSpec.describe TimePassed do

  it 'returns year format when posted a year ago' do
    time_since_update = 18.months.ago

    # sample: Jan, 2020
    year_format = time_since_update.strftime("%b, %Y") 

    expect(TimePassed.format(time_since_update)).to eq(year_format)
  end

  it 'returns month format posted a week ago' do
    time_since_update = 17.days.ago

    # sample: Jan 08
    month_format = time_since_update.strftime("%b %d")

    expect(TimePassed.format(time_since_update)).to eq(month_format)
  end

  it 'returns day format when posted a day ago' do
    time_since_update = 48.hours.ago

    # sample: Sunday
    day_format = time_since_update.strftime("%A")

    expect(TimePassed.format(time_since_update)).to eq(day_format)
  end

  it 'returns hour format when posted an hour ago' do
    time_since_update = 3.hours.ago

    # TimeAgo module floors results thus 1 hr late
    #   even if current time is milliseconds early
    hour_format = '2 hr'

    expect(TimePassed.format(time_since_update)).to eq(hour_format)
  end

  it 'returns minute format if posted not more than an hour ago' do
    time_since_update = 48.minutes.ago

    # TimeAgo module floors results thus 1 minute late
    #   even if current time is milliseconds early
    minute_format = '47 min'

    expect(TimePassed.format(time_since_update)).to eq(minute_format)
  end
end