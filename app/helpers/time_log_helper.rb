module TimeLogHelper
  def unupdatable_message(time_log)
    case time_log.user_updatable_status
    when :time_over then "変更ができるのは打刻後60分以内です"
    when :non_target then "変更できるのは最新の打刻だけです"
    when :uncomplete then "まだ終了していません"
    end
  end
end
