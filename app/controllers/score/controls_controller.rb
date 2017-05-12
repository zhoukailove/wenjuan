class Score::ControlsController < ScoreController

  # 大屏显示页面
  def show_message
    @control_center = Score::ControlCenter.first
    control_id = Score::Control.where('id = ? and status = ?',params[:id],false).last.try(:id)
    @records = []
    @records = Score::Record.where('control_id = ?',control_id) if control_id

  end
end
