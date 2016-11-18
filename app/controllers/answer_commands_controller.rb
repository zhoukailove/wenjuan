class AnswerCommandsController < ApplicationController
  before_action :set_answer_command, only: [:show, :edit, :update, :destroy]

  # GET /answer_commands
  # GET /answer_commands.json
  def index
    @answer_commands = AnswerCommand.all
  end

  # GET /answer_commands/1
  # GET /answer_commands/1.json
  def show
  end

  # GET /answer_commands/new
  def new
    @answer_command = AnswerCommand.new
  end

  # GET /answer_commands/1/edit
  def edit
  end

  # POST /answer_commands
  # POST /answer_commands.json
  def create
    @answer_command = AnswerCommand.new(answer_command_params)

    respond_to do |format|
      if @answer_command.save
        format.html { redirect_to @answer_command, notice: 'Answer command was successfully created.' }
        format.json { render :show, status: :created, location: @answer_command }
      else
        format.html { render :new }
        format.json { render json: @answer_command.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answer_commands/1
  # PATCH/PUT /answer_commands/1.json
  def update
    respond_to do |format|
      if @answer_command.update(answer_command_params)
        format.html { redirect_to @answer_command, notice: 'Answer command was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer_command }
      else
        format.html { render :edit }
        format.json { render json: @answer_command.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answer_commands/1
  # DELETE /answer_commands/1.json
  def destroy
    @answer_command.destroy
    respond_to do |format|
      format.html { redirect_to answer_commands_url, notice: 'Answer command was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer_command
      @answer_command = AnswerCommand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_command_params
      params.require(:answer_command).permit(:answer_id, :begin_time, :end_time, :status)
    end
end
