require 'rails_helper'

feature 'time_logs' do
  let(:time) { Time.zone.local 2015, 8, 20, 12, 30 }
  let(:start_time) { time - 1.hour }
  let(:end_time) { time }
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user, start_at: start_time, original_start_at: start_time, end_at: end_time, original_end_at: end_time }

  background do
    user_login
    Timecop.travel(time)
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  # to_sしないと同じ時間でも比較できない
  scenario "shorten hours" do
    visit time_log_path(time_log)
    expect {
      select end_time.min - 10, from: 'time_log_end_at_5i'
      click_button "変更"
      time_log.reload
    }.to change{ time_log.end_at.to_s }.from(end_time.to_s).to((end_time - 10.minute).to_s)
  end

  scenario "inversion time" do
    visit time_log_path(time_log)
    expect {
      select end_time.day - 1, from: 'time_log_end_at_3i'
      click_button "変更"
      time_log.reload
    }.to_not change{ time_log.end_at.to_s }
    expect(page).to have_content "終了時刻が開始時刻より前です"
  end

  scenario "lengthen hours" do
    visit time_log_path(time_log)
    expect {
      select end_time.min + 10, from: 'time_log_end_at_5i'
      click_button "変更"
      time_log.reload
    }.to_not change{ time_log.end_at.to_s }
    expect(page).to have_content "延長はできません"
  end

  scenario "time over" do
    Timecop.travel(time + 2.hour)
    visit time_log_path(time_log)
    expect(page).to have_content "変更ができるのは打刻後60分以内です"
  end

  scenario "non-latest" do
    time_log
    FactoryGirl.create :time_log, user: user, start_at: start_time, original_start_at: start_time, end_at: end_time, original_end_at: end_time
    visit time_log_path(time_log)
    expect(page).to have_content "変更できるのは最新の打刻だけです"
  end

  scenario "non-complete" do
    time_log = FactoryGirl.create :time_log, user: user, start_at: start_time, original_start_at: start_time, end_at: nil, original_end_at: nil
    visit time_log_path(time_log)
    expect(page).to have_content "まだ終了していません"
  end
end
