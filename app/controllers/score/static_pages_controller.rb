class Score::StaticPagesController < ScoreController

  def home
    @users = ping_fen_pan_duan
  end

  # 判断开关
  def ping_fen_pan_duan
    control_center = Score::ControlCenter.first
    if control_center
      # 评分是否已经结束
      if control_center.status
        # 是否选择好评委编号
        if cookies[:user_id] && Score::User.find_by_id(cookies[:user_id])
          redirect_to select_fen_score_user_path(cookies[:user_id])
        else
          cookies[:user_id] = false
          if Score::User.where('state = ? ',false).present?
            Score::User.all
          else
            redirect_to score_active_is_over_path
          end
        end
      else
        #   活动已经结束
        redirect_to score_active_is_over_path
      end
    else
      #   未初始化
      redirect_to score_active_is_over_path

    end
  end

  def active_is_over
    users = Score::User.all
    @users = users ? users : []
    # logger.info  @users
  end

end
