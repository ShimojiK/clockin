module TimeLogHelper
  def unupdatable_message(status)
    case status
    when :time_over then "変更ができるのは打刻後60分以内です"
    when :non_target then "変更できるのは最新の打刻だけです"
    when :uncomplete then "まだ終了していません"
    when :lengthen   then "延長はできません"
    end
  end
end
