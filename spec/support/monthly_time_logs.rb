module MonthlyTimeLogs
  class << self
    def create_monthly_time_logs(user, *time)
      time = Time.zone.local(*time)
      (1..3).each do |i|
        3.times do |j|
          # 各月にi時間働いた記録を作る
          # それぞれが重ならないようにするためj * 4
          start_at = time - i.pred.month + (j * 4).hour
          end_at = time - i.pred.month + (j * 4 + i).hour
          FactoryGirl.create(
            :time_log,
            user: user,
            start_at: start_at,
            original_start_at: start_at,
            end_at: end_at,
            original_end_at: end_at)
        end
      end
    end
  end
end
