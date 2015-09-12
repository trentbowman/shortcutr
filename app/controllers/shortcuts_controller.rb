class ShortcutsController < ApplicationController
  before_action :set_shortcut, only: [:show, :edit, :update, :destroy]

  # GET /shortcuts
  # GET /shortcuts.json
  def index
    @shortcuts = Shortcut.all
  end

  # GET /shortcuts/1
  # GET /shortcuts/1.json
  def show
  end

  # GET /shortcuts/new
  def new
    @shortcut = Shortcut.new
  end

  # GET /shortcuts/1/edit
  def edit
  end

  # POST /shortcuts
  # POST /shortcuts.json
  def create
    @shortcut = Shortcut.new(shortcut_params)
    @shortcut.assign_target

    respond_to do |format|
      if @shortcut.save
        format.html { redirect_to @shortcut, notice: 'Shortcut was successfully created.' }
        format.json { render :show, status: :created, location: @shortcut }
      else
        format.html { render :new }
        format.json { render json: @shortcut.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shortcuts/1
  # PATCH/PUT /shortcuts/1.json
  def update
    respond_to do |format|
      if @shortcut.update(shortcut_params)
        format.html { redirect_to @shortcut, notice: 'Shortcut was successfully updated.' }
        format.json { render :show, status: :ok, location: @shortcut }
      else
        format.html { render :edit }
        format.json { render json: @shortcut.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shortcuts/1
  # DELETE /shortcuts/1.json
  def destroy
    @shortcut.destroy
    respond_to do |format|
      format.html { redirect_to shortcuts_url, notice: 'Shortcut was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shortcut
      @shortcut = Shortcut.with_normalized_target(params[:target]).first
      raise ActiveRecord::RecordNotFound.new("No Shortcut found with target='#{params[:target]}'") unless @shortcut
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shortcut_params
      params.require(:shortcut).permit(:url, :target)
    end
end
