class StaticPagesController < AdminsController
  before_action :logged_in_user, only: [:home]
  before_action :update_answer, only: [:home]

  def home
    @modal = 0
    @title = 'Home | Ruby on Rails Tutorial Sample App'
    if current_user
      if current_user.id == User.last.id
        redirect_to answer_commands_path
      else


        # && current_user.status
        answer_records = current_user.answer_records

        unless answer_records.pluck(:id).present?

          msg = get_answer 1
          # logger.info msg
          if (msg[0])
            @answer = msg[1]
            @modal = msg[2]
          else
            redirect_to active_end_path
          end
        else

          # is_ok = answer_records.where('status in (?)', [0, 2]).pluck(:answer_id, :status)
          # logger.info "=#{is_ok}==="
          is_ok = AnswerCommand.where('status = ?', true).first
          # if is_ok.present?
          unless is_ok.present?
            redirect_to active_end_path
          else
            logger.info "=="

            answer_id = (answer_records.last.answer_id + 1)
            msg = get_answer answer_id
            logger.info "#{msg}=="
            if msg[0]
              @answer = msg[1]
              @modal = msg[2]
              # render layout: "answer_application"
            else
              redirect_to active_end_path
            end
          end
        end
      end
    else
      redirect_to login_path
    end
  end

  def post_answer
    # id: id,
    #     values: values
    id = params[:id]
    answers = params[:answers]
    state = params[:state]

    data = 500
    times = 0
    timess = 0
    begin_time = 0
    # if current_user && current_user.status && id && @answer_record = AnswerRecord.where('answer_id = ? and user_id = ?',id,current_user.id)
    if current_user && id
      @answer_record = AnswerRecord.where('answer_id = ? and user_id = ?', id, current_user.id)
      unless @answer_record.try(:first)
        time = Time.now
        times = time.strftime "%Y-%m-%d %H:%M:%S"
        answer_command = AnswerCommand.where('answer_id = ?', id)
        if answer_command
          answer_command = answer_command.first
          if answer_command.begin_time
            if !answer_command.end_time
              begin_time = answer_command.begin_time
              timess = time - answer_command.begin_time.to_time
              logger.info "#{state == 'true'}==========="
              if state == 'true'
                status = 2
              else
                status = answers.join == params[:value_s].join ? 1 : 0
              end
              current_user.update(status: 0) if status != 1
              ty = AnswerRecord.create(answer_id: id, user_id: current_user.id, time_cost: timess, status: status)
              data = 200 if ty
            else
              # current_user.update(status: 0)
              # AnswerRecord.create(answer_id:id,user_id:current_user.id,time_cost:0.0,status:2)
              msg = '答题结束'
            end
          else
            msg = '答题未开始'
          end
        else
          msg = '没有可答问题'
        end
      else
        msg = '已经答过了'
      end
    else
      msg = '错误'
    end
    info = {data: data, msg: msg, time: times, timess: timess, begin_time: begin_time}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  def get_time
    # id: id,
    #     time_type:
    id = params[:id]
    time_type = params[:time_type]
    data = 500
    msg = ''
    # if current_user && current_user.status && id
    if current_user && id
      answer_command = AnswerCommand.where("answer_id = ? ", id).try(:first)
      if answer_command
        if answer_command.try(:status)
          if answer_command.try(time_type)
            data=200
            #   答题开始或结束
          else
            data = 100
            #   答题未开始或未结束
          end
        else
          data = 300
          #   答题结束、跳转主活动页面
        end
      else
        msg = '已经答过了'
      end
    else
      msg = '错误'
    end

    info = {data: data, msg: msg, }
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end

  end

  def update_answer
    answer_ids = AnswerCommand.where('status = ?', false).pluck(:answer_id)
    answer_ids.each do |id|
      answer_record = AnswerRecord.where('user_id = ? and answer_id = ?', current_user.id, id)
      unless answer_record.present?
        AnswerRecord.create(answer_id: id, user_id: current_user.id, time_cost: 0.0, status: 2)
      end
    end
    redirect_to active_end_path unless AnswerCommand.where('status = ?', true).present?
  end

  def get_answer answer_id
    result = false
    modal = 0
    ty = false
    answer_command = AnswerCommand.where('status = ?', true)
    result = if answer_command.present?

               file_path = 'php_git_pull_date.yaml'
               if File::exists?(file_path)
                 answer = YAML.load_file(file_path)
                 if answer
                   pid = AnswerCommand.where('answer_id = ?',answer_id).first.pid
                   answer = answer[pid]
                   answer.each do |k,val|
                     # logger.info "  ===#{val.to_json}@@@"

                     if val[:id] == answer_id
                       val[:sort] = k
                       result = val
                     end
                   end
                   if result
                     answer_command = AnswerCommand.find_by_answer_id(answer_id)
                     if answer_command.begin_time
                       if !answer_command.end_time
                         modal = 1
                       end
                     end
                     ty = true
                     result
                   else
                     '题库错误'
                   end
                 else
                   '题库未记录'
                 end
               else
                 '题库不存在'
               end
             else
               '答题结束'
             end
    [ty, result, modal]
  end




  def get_answers answer_id
    # answer_id = 0
    result = false
    modal = 0
    ty = false
    answer_command = AnswerCommand.where('status = ?', true)
    result = if answer_command.present?
               answer_id += 1
               if answer_command.first.answer_id <= answer_id
                 file_path = 'php_git_pull_date.yaml'
                 if File::exists?(file_path)
                   answer = YAML.load_file(file_path)
                   if answer
                     pid = answer_command.first.pid
                     answer = answer[pid]
                     answer.each do |k,val|
                       if val[:id] == answer_id
                         val[:sort] = k
                         result = val
                       end
                     end

                     # result = answer[:Q1]
                     if result
                       answer_command = AnswerCommand.find_by_answer_id(answer_id)
                       if answer_command.begin_time
                         if !answer_command.end_time
                           modal = 1
                         end
                       end
                       ty = true
                       result
                     else
                       '题库错误'
                     end
                   else
                     '题库未记录'
                   end
                 else
                   '题库不存在'
                 end
               else
                 answer_record = AnswerRecord.where('user_id = ? and answer_id = ?', 1, answer_id)
                 unless answer_record.present?
                   AnswerRecord.create(answer_id: answer_id, user_id: 1, time_cost: 0.0, status: 2)
                 end
                 get_answers answer_id

                 # '错过未答，不能答题'
               end
             else
               '答题结束'
             end
    [ty, result, modal]
  end

  def help
    @title = 'Help | Ruby on Rails Tutorial Sample App'
  end
end
