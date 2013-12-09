class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  def json_output
    min_max_array = params[:decade].split(',')
    @min = min_max_array[0]
    @max = min_max_array[1]
    @decade_popular = HTTParty.get("http://api.menus.nypl.org/dishes?token=selsce5qphehgzeqw2cke6jb2e&min_year=#{@min}&max_year=#{@max}&sort_by=popularity")
    output = []


    @decade_popular["dishes"][0..9].each do |dish|
      img_name = dish["name"].gsub(/[^\w]/, "");

      output << {
          startDate: ["1850","#{dish["first_appeared"]}"].max,
          endDate: ["2012","#{dish["last_appeared"]}"].min,
          headline: dish["name"],
          asset: {media: "http://#{img_name}.jpg.to"}
      }
    end

    json_obj = {
      timeline: {
      headline:"Dish on Dishes",
      type:"default",
      text:"Brought to you by NYPL",
      startDate: "#{@min}",
      date: output
      }
    };

    respond_to do |format|
      format.json { render json:json_obj }
    end

  end

  # GET /foods
  # GET /foods.json
  def index
    min_max_array = params[:decade].split(',')
    @min = min_max_array[0]
    @max = min_max_array[1]
    @decade_popular = HTTParty.get("http://api.menus.nypl.org/dishes?token=selsce5qphehgzeqw2cke6jb2e&min_year=#{@min}&max_year=#{@max}&sort_by=popularity")
    @decade_obscure = HTTParty.get("http://api.menus.nypl.org/dishes?token=selsce5qphehgzeqw2cke6jb2e&min_year=#{@min}&max_year=#{@max}&sort_by=obscurity")
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
  end

  def local_menu_search
    @name = params[:name].split(' ').join('+')
    @local_search = HTTParty.get("http://api.locu.com/v1_0/menu_item/search/?api_key=6aa048a34d1b96643052e2b69318afddb0b53b21&name=#{@name}&radius=1000")
    if @local_search.length > 50
      @local_search = @local_search[0..49]
    end
  end

  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit
  end

  # POST /foods
  # POST /foods.json
  def create
    @food = Food.new(food_params)

    respond_to do |format|
      if @food.save
        format.html { redirect_to @food, notice: 'Food was successfully created.' }
        format.json { render action: 'show', status: :created, location: @food }
      else
        format.html { render action: 'new' }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to @food, notice: 'Food was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    @food.destroy
    respond_to do |format|
      format.html { redirect_to foods_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:dish, :year, :qty)
    end
end
