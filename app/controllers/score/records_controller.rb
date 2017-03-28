class Score::RecordsController < ScoreController
  before_action :set_score_record, only: [:show, :edit, :update, :destroy]

  # GET /score/records
  # GET /score/records.json
  def index
    @score_controls = Score::Control.all
  end

  def update_command_time
    id = params[:concle_id]
    column_type = params[:column_type]
    column_type = (column_type == 'begin_time') ? :begin_status : :end_status
    data = 500
    if id && @score_control = Score::Control.find_by_id(id)
      if @score_control.status
        if column_type == :end_status
          date = {status:false,end_status:true,begin_status:true}
          Score::Record.where('status = ? and control_id = ?',false,id).update_all(status:true,number:0)
        else
          date = {begin_status:true}
        end
        if @score_control.update(date)
          data = 200
          msg = '更新完成'
        else
          msg = '更新失败'
        end
      else
        msg = '已经结束'
      end
    else
      msg = '未知错误'
    end
    info = {data: data, msg: msg}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end


  def update_command_times
    control_id = params[:control_id]
    column_type = params[:column_type]


    info = {status: state,state: status, redirect_to_url: redirect_to_url, msg: msg}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  # GET /score/records/1
  # GET /score/records/1.json
  def show
  end

  # 大屏显示页面
  def show_message
    control_id = Score::Control.where('status = ?',false).last.try(:id)
    @records = []
    @records = Score::Record.where('control_id = ?',control_id) if control_id

  end

  def info_production
    # 删除所有用户的记录信息
    Score::User.update_all(status:true,state:false)
    Score::Record.update_all(status:false,number:0)
    Score::Control.update_all(status:true,begin_status:false,end_status:false)
    redirect_to score_records_path
  end
  def info_fen
    # 删除所有用户的记录信息
    Score::Control.update_all(status:false,begin_status:true,end_status:true)
    redirect_to score_records_path
  end

  # 更新用户评分记录
  def update_user_record
    @user_id = cookies[:user_id]
    @control_id = params[:control_id]
    redirect_to_url = ''
    @fen = params[:fen]
    if @fen && @user_id && Score::User.find_by_id(@user_id) && @control_id && Score::Control.find_by_id(@control_id)
      Score::Record.where('user_id = ? and control_id = ?',
                          @user_id, @control_id).
          update_all( status:true, number:@fen )
      redirect_to_url = select_fen_score_user_path(@user_id)

      end
    if Score::Control.last.id == @control_id
      redirect_to_url = score_active_is_over_path
    end

    info = { msg: '完成',redirect_to_url:redirect_to_url}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  # GET /score/records/new
  def new
    @score_record = Score::Record.new
  end

  # GET /score/records/1/edit
  def edit
  end

  # POST /score/records
  # POST /score/records.json
  def create
    @score_record = Score::Record.new(score_record_params)

    respond_to do |format|
      if @score_record.save
        format.html { redirect_to @score_record, notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: @score_record }
      else
        format.html { render :new }
        format.json { render json: @score_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /score/records/1
  # PATCH/PUT /score/records/1.json
  def update
    respond_to do |format|
      if @score_record.update(score_record_params)
        format.html { redirect_to @score_record, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @score_record }
      else
        format.html { render :edit }
        format.json { render json: @score_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /score/records/1
  # DELETE /score/records/1.json
  def destroy
    @score_record.destroy
    respond_to do |format|
      format.html { redirect_to score_records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score_record
      @score_record = Score::Record.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_record_params
      params.require(:score_record).permit(:user_id,:control_id, :number, :fraction, :status)
    end
end
