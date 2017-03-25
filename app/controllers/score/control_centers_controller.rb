class Score::ControlCentersController < ScoreController
  before_action :set_score_control_center, only: [:show, :edit, :update, :destroy]

  # GET /score/control_centers
  # GET /score/control_centers.json
  def index
    @score_control_centers = Score::ControlCenter.all
  end

  # GET /score/control_centers/1
  # GET /score/control_centers/1.json
  def show
  end

  # GET /score/control_centers/new
  def new
    @score_control_center = Score::ControlCenter.new
  end

  # GET /score/control_centers/1/edit
  def edit
  end

  # POST /score/control_centers
  # POST /score/control_centers.json
  def create
    Score::ControlCenter.delete_all
    @score_control_center = Score::ControlCenter.new(score_control_center_params)

    respond_to do |format|
      if @score_control_center.save
        user = []
        people_number = @score_control_center.people_number
        if people_number
          Score::User.delete_all
          1..people_number.times do |i|
            user <<  [i+1,"评委#{(i+1)}",true,false]
          end
        end
        round_number = @score_control_center.round_number
        record = []
        control = []
        if round_number
          Score::Control.delete_all
          Score::Record.delete_all
          1..round_number.times do |i|
            control << [i+1,false,false,i+1,true]
            1..people_number.times do |j|
              record << [ i+1,   j+1, 0, false]
            end
          end
        end
        Score::User.transaction do
          begin
            Score::User.import!([:id,:name,:status,:state],user)
          rescue => e
            puts "user报错信息:#{e}"
          end
          end
        Score::Control.transaction do
          begin
            Score::Control.import([:id,:begin_status,:end_status,:round_number,:status],control)
          rescue => e
            puts "user报错信息:#{e}"
          end
          end
        Score::Record.transaction do
          begin
            Score::Record.import!([:control_id,:user_id,:fraction,:status],record)
          rescue => e
            puts "user报错信息:#{e}"
          end
        end
        format.html { redirect_to @score_control_center, notice: 'Control center was successfully created.' }
        format.json { render :show, status: :created, location: @score_control_center }
      else
        format.html { render :new }
        format.json { render json: @score_control_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /score/control_centers/1
  # PATCH/PUT /score/control_centers/1.json
  def update
    respond_to do |format|
      if @score_control_center.update(score_control_center_params)
        format.html { redirect_to @score_control_center, notice: 'Control center was successfully updated.' }
        format.json { render :show, status: :ok, location: @score_control_center }
      else
        format.html { render :edit }
        format.json { render json: @score_control_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /score/control_centers/1
  # DELETE /score/control_centers/1.json
  def destroy
    @score_control_center.destroy
    respond_to do |format|
      format.html { redirect_to score_control_centers_url, notice: 'Control center was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score_control_center
      @score_control_center = Score::ControlCenter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_control_center_params
      params.require(:score_control_center).permit(:begin_time, :end_time, :fraction, :people_number, :round_number, :status)
    end
end
