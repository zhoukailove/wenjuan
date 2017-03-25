class Score::UsersController < ScoreController
  before_action :set_score_user, only: [:show, :edit, :update, :destroy]

  # GET /score/users
  # GET /score/users.json
  def index
    @score_users = Score::User.all
    @user = Score::User.all
  end

  # GET /score/users/1
  # GET /score/users/1.json
  def show
  end

  def get_user_state
    user_id = params[:user_id]
    state = false
    if user_id
      @user = Score::User.find(user_id)
      if @user
        state = @user.state
        user_id = @user.id
        unless state
          cookies[:user_id] = user_id
          @user.update(state: true)
        end
      end
    end
    info = {status: state, user_id: user_id}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  # 用户评分页面
  def select_fen
    @co_user_id = cookies[:user_id]
    @pa_user_id = params[:id]
    if @co_user_id == @pa_user_id
      control_db = Score::Control
      # 默认为true

      #   得到当前有效的轮数号码
      controls = control_db.where('status = ?', true)
      @control_id = controls.first.try(:id)
      last_id = control_db.last.id
      @control_id = @control_id ? @control_id : last_id
      record = Score::Record.where('user_id = ? and control_id = ? and status = ?', @co_user_id,@control_id, true)
      if last_id == @control_id
        if record.present?
          redirect_to score_active_is_over_path
        end
      else
        @control_id = controls[1].try(:id) if record.present?
      end

      logger.info "#@control_id ========"
      #   得到已经结束的轮数号码
      control_ids_false = control_db.where('status = ?', false).pluck(:id)
      #   更新已经结束的轮数中用户没有做出评分的记录
      Score::Record.where('user_id = ? and control_id in (?) and status = ?', @co_user_id, control_ids_false, false).update(status: true, number: 0) if control_ids_false.present?
    else
      redirect_to score_root_path
    end
  end

  # 评分是否开始功能，用于轮询
  def get_pingfeng_is_begin
    control_center = Score::ControlCenter.first
    redirect_to_url = score_active_is_over_path
    record_db = Score::Record
    state = false  # 蒙板是否显示
    status = false #控制是否跳转
    msg = ''
    if control_center
      if control_center.status
        control = Score::Control.find_by_id(params[:control_id])
        if control #当前轮
          if control.status #当前轮有效
            if control.begin_status # 已经开始
              if control.end_status # 已经结束
                if Score::Control.last.id == params[:control_id] # 是最后一轮
                  msg += '是最后一轮'
                else
                  msg += '评分已结束,进入下一轮评分'
                  redirect_to_url = select_fen_score_user_path(cookies[:user_id])
                end
                record = record_db.where('user_id = ? and  control_id = ?', cookies[:user_id], params[:control_id])
                if record
                  if !record.status
                    record.update(status: true, number: 0)
                    msg += '用户未评分默认为0分'
                  end
                end
              else
                msg += '当前评分开始，但用户还未评分'
                status = true
                state = true
              end
            else
              msg += '等待评分开始'
              status = true
              state = false
            end
          else
            if Score::Control.last.id == params[:control_id] # 是最后一轮
            #   msg += '是最后一轮'
            else
            #   msg += '进入下一轮评分'
              redirect_to_url = select_fen_score_user_path(cookies[:user_id])
            end
            # msg += '等待评分开始'
            # status = true
            # state = false
          end
        end
      else
        msg += '评分已结束'
      end
    else
      msg += '评分系统未初始化'
    end
    info = {status: status,state: state, redirect_to_url: redirect_to_url, msg: msg}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end

  end

  # GET /score/users/new
  def new
    @score_user = Score::User.new

  end

  # GET /score/users/1/edit
  def edit
  end

  def edit_all

    @score_users = Score::User.all

  end

  def update_all
    @score_user_db = Score::User
    #   params.require(:person).permit(contact: [ :email, :phone ])
    Score::User.all.pluck(:id).each do |id|
       user = params["score_user_#{id}"]
       data = {}
      if user
        if user[1]
          data.merge!( {name:user[1]})
        end
        if user[2]
          data.merge!( {avatar:user[2]})

        end
        @score_user_db.find_by_id(id).update(data)

      end
    end
    redirect_to score_records_path
  end

  # POST /score/users
  # POST /score/users.json
  def create
    @score_user = Score::User.new(score_user_params)

    respond_to do |format|
      if @score_user.save
        format.html { redirect_to score_users_url, notice: 'User was successfully create.' }

      else
        format.html { render :new }
        format.json { render json: @score_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /score/users/1
  # PATCH/PUT /score/users/1.json
  def update
    respond_to do |format|
      if @score_user.update(score_user_params)
        format.html { redirect_to score_users_url, notice: 'User was successfully update.' }
      else
        format.html { render :edit }
        format.json { render json: @score_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /score/users/1
  # DELETE /score/users/1.json
  def destroy
    @score_user.destroy
    respond_to do |format|
      format.html { redirect_to score_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_score_user
    @score_user = Score::User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def score_user_params
    params.require(:score_user).permit(:name, :status, :state, :avatar)
  end

end
