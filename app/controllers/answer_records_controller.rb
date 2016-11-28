class AnswerRecordsController < ApplicationController
  before_action :set_answer_record, only: [:show, :edit, :update, :destroy]


  def record_detail
    answer_record_db = AnswerRecord
    answer_id = params[:answer_id]
    # answer_id = 3
    answer_records = answer_record_db.where('answer_id = ?', answer_id)
    if answer_records.present?
      count = answer_records.count
      correct = answer_records.where('status = ?', 1).count
      failing = answer_records.where('status = ?', 0).count
      status_true = failing + correct
      status_false = count - status_true
      dat = {
          status: true,
          answer_id: answer_id,
          status_true: (count>0 && status_true>0) ? (sprintf("%.4f", status_true.to_f/count)) : 0.00,
          status_false: (count>0 && status_false>0) ? (sprintf("%.4f", status_false.to_f/count)) : 0.00,
          correct: correct,
          correct_robability: (count>0 && correct>0) ? (sprintf("%.4f", correct.to_f/count)) : 0.00,
          failing: failing,
          failing_robability: (count>0 && failing>0) ? (sprintf("%.4f", failing.to_f/count)) : 0.00,
      }
    else
      dat = {answer_id: answer_id, status: false}
    end
    @result = [dat]
  end

  # GET /answer_records
  # GET /answer_records.json
  def index
    answer_commands = AnswerCommand.all
    answer_record_db = AnswerRecord

    @result = []
    status_true = 0
    status_false = 0
    correct = 0
    count = 0
    failing = 0
    answer_commands.each do |answer_command|
      answer_id = answer_command.answer_id
      answer_records = answer_record_db.where('answer_id = ?', answer_id)
      if answer_records.present?
        count = answer_records.count
        correct = answer_records.where('status = ?', 1).count
        failing = answer_records.where('status = ?', 0).count
        status_true = failing + correct
        status_false = count - status_true
        dat = {
            status: true,
            answer_id: answer_id,
            status_true: status_true,
            status_false: status_false,
            correct: correct,
            correct_robability: (count>0 && correct>0) ? (sprintf("%.2f", correct.to_f/count)) : 0.00,
            failing: failing,
            failing_robability: (count>0 && failing>0) ? (sprintf("%.2f", failing.to_f/count)) : 0.00,
        }
      else
        dat = {answer_id: answer_id, status: false}
      end
      @result << dat

    end
  end

  def get_answer_records
    @answer_id = AnswerCommand.where('status = ? and begin_time is not ? and end_time is ?', true, nil, nil).first.try(:answer_id)
    d = false
    if @answer_id
      if cookies["old_answer_id"].present?
        if cookies["old_answer_id"] != @answer_id
          d = true
          cookies["old_answer_id"] = @answer_id
        end
      else
        cookies["old_answer_id"] = @answer_id
      end
      @answer_records = AnswerRecord.where('answer_id = ?', @answer_id).pluck(:user_id, :status)
    end
    @answer_records ||= []
    info = {data: @answer_records, state: d,answer_id:@answer_id,cook:cookies["old_answer_id"]}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  def get_answer_record
    @answer_id = AnswerCommand.where('status = ? and answer_id = ?', false, params[:answer_id]).last.try(:answer_id)
    if @answer_id
      record_answer_ids = cookies["record_answer_ids_#@answer_id"].present? ? JSON.parse(cookies["record_answer_ids_#@answer_id"]) : false
      answer_records = AnswerRecord.where('answer_id = ?', @answer_id)
      if record_answer_ids
        @answer_records = answer_records.where('id not in (?)', record_answer_ids)
        if @answer_records.present?
          @answer_record_ids = @answer_records.pluck(:id)
          cookies["record_answer_ids_#@answer_id"] = (record_answer_ids+@answer_record_ids).to_json
          @answer_records = @answer_records.pluck(:user_id, :status)
        end
      else
        @answer_records = answer_records
        if @answer_records.present?
          @answer_record_ids = @answer_records.pluck(:id)
          cookies["record_answer_ids_#@answer_id"] = (@answer_record_ids).to_json
          @answer_records = @answer_records.pluck(:user_id, :status)
        end
      end
    else
    end
    @answer_records ||= []
    info = {data: @answer_records}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  def user_table
    @user = User.order(:id);
    cookies.delete("old_answer_id")
    # cookies["record_answer_ids_#{params[:answer_id]}"] = nil
    # cookies.delete ("record_answer_ids_#{params[:answer_id]}")

  end

  def feedback_crawling
    @limit = params[:limit] ? params[:limit] : 6
    count_number = AnswerCommand.where('status = ?', false).count
    @answer_records = AnswerRecord.select('count(user_id) as count_number,avg(time_cost) as time_costs , user_id').
        where('status = ?', true).
        # group('user_id').having('count_number = ? ',count_number).
        order('time_costs').limit(@limit)

  end

  def feedback_record
    answer_id = params[:id]
    if (answer_id)
      @answer_records = AnswerRecord.where('answer_id = ? and status in (?)', answer_id, [0, 1]).order("status desc ,time_cost ")
      @answer_recordss = AnswerRecord.where('answer_id = ? and status = 2', answer_id)
    end
  end

  # GET /answer_records/1
  # GET /answer_records/1.json
  def show
  end

  def answer_show
    answer_command = AnswerCommand.where('status = ?', false).last
    @correct_rate = 0.0
    @failing_rate = 0.0
    @record_all_rate = 0.0
    @record_false_rate = 0.0
    @answer_id = 0
    if answer_command.present?
      answer_id = answer_command.answer_id
      @answer_id = answer_id
      @answer_record = AnswerRecord.where('answer_id = ?', answer_id)
      @record_false = @answer_record.where('status = ?', 0).count
      @record_true = @answer_record.where('status = ?', 1).count
      count = User.count
      @record_all = @record_false + @record_true
      @record_all_rate = (sprintf("%.2f", @record_all.to_f/count)) # 反馈人数率
      @record = count - @record_all
      @record_false_rate = (sprintf("%.2f", @record.to_f/count)) # 未反馈人数率

      @correct_rate = (sprintf("%.2f", @record_true.to_f/count)) #正确率
      @failing_rate = (sprintf("%.2f", @record_false.to_f/count)) #错误率
    end
  end

  # GET /answer_records/new
  def new
    @answer_record = AnswerRecord.new
  end

  # GET /answer_records/1/edit
  def edit
  end

  # POST /answer_records
  # POST /answer_records.json
  def create
    @answer_record = AnswerRecord.new(answer_record_params)

    respond_to do |format|
      if @answer_record.save
        format.html { redirect_to @answer_record, notice: 'Answer record was successfully created.' }
        format.json { render :show, status: :created, location: @answer_record }
      else
        format.html { render :new }
        format.json { render json: @answer_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answer_records/1
  # PATCH/PUT /answer_records/1.json
  def update
    respond_to do |format|
      if @answer_record.update(answer_record_params)
        format.html { redirect_to @answer_record, notice: 'Answer record was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer_record }
      else
        format.html { render :edit }
        format.json { render json: @answer_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answer_records/1
  # DELETE /answer_records/1.json
  def destroy
    @answer_record.destroy
    respond_to do |format|
      format.html { redirect_to answer_records_url, notice: 'Answer record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_answer_record
    @answer_record = AnswerRecord.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def answer_record_params
    params.require(:answer_record).permit(:user_id, :answer_id, :time_cost, :status)
  end
end
