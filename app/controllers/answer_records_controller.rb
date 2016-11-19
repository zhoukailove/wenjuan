class AnswerRecordsController < ApplicationController
  before_action :set_answer_record, only: [:show, :edit, :update, :destroy]

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
      answer_records = answer_record_db.where('answer_id = ?',answer_id )
      if answer_records.present?
        count = answer_records.count
        correct = answer_records.where('status = ?',1).count
        failing = answer_records.where('status = ?',0).count
        status_true = failing + correct
        status_false = count - status_true
        dat = {
            status: true,
            answer_id: answer_id,
                    status_true:status_true,
                    status_false: status_false,
                    correct:correct,
                    correct_robability: (count>0 &&  correct>0) ? (sprintf("%.2f",correct.to_f/count)) : 0.00,
                    failing:failing,
                    failing_robability:(count>0 &&  failing>0) ? (sprintf("%.2f",failing.to_f/count)): 0.00,
        }
      else
        dat = { answer_id: answer_id,status: false}
      end
      @result << dat

    end
  end

  def feedback_crawling
    @limit = params[:limit] ? params[:limit] : 6
    count_number = AnswerCommand.where('status = ?' ,false).count
    @answer_records = AnswerRecord.select('count(user_id) as count_number,avg(time_cost) as time_costs , user_id').
        where('status = ?',true).
        # group('user_id').having('count_number = ? ',count_number).
        order('time_costs').limit(@limit)

  end

  def feedback_record
    answer_id = params[:id]
    if(answer_id)
      @answer_records = AnswerRecord.where('answer_id = ? and status in (?)', answer_id,[0,1]).order("status desc ,time_cost ")
      @answer_recordss = AnswerRecord.where('answer_id = ? and status = 2', answer_id)
    end
  end

  # GET /answer_records/1
  # GET /answer_records/1.json
  def show
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
