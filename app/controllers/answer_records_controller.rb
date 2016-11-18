class AnswerRecordsController < ApplicationController
  before_action :set_answer_record, only: [:show, :edit, :update, :destroy]

  # GET /answer_records
  # GET /answer_records.json
  def index
    @answer_records = AnswerRecord.all
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
      params.require(:answer_record).permit(:user_id, :answer_id, :time_cost, :status, :state)
    end
end
