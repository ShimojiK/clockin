module UserHelper
  def stringify_seconds(seconds)
    "#{seconds / 3600}時間#{format("%02d", seconds % 3600 / 60)}分"
  end
end
