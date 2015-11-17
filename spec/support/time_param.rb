module TimeParam
  def params_from_time(time, column)
    {
      "#{column}(1i)" => time.year.to_s,
      "#{column}(2i)" => justify(time.month),
      "#{column}(3i)" => justify(time.day),
      "#{column}(4i)" => justify(time.hour),
      "#{column}(5i)" => justify(time.min),
    }
  end

  private
  def justify(num)
    format("%02d", num)
  end
end
