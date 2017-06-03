class DatacastAccountsController < ApplicationController
  before_action :set_datacast_account, only: [:show, :edit, :update, :destroy]

  # GET /datacast_accounts
  # GET /datacast_accounts.json
  def index
    @datacast_accounts = DatacastAccount.all
  end

  # GET /datacast_accounts/1
  # GET /datacast_accounts/1.json
  def show
  end

  # GET /datacast_accounts/new
  def new
    @datacast_account = DatacastAccount.new
  end

  # GET /datacast_accounts/1/edit
  def edit
  end

  # POST /datacast_accounts
  # POST /datacast_accounts.json
  def create
    @datacast_account = DatacastAccount.new(datacast_account_params)

    respond_to do |format|
      if @datacast_account.save
        format.html { redirect_to @datacast_account, notice: 'Datacast account was successfully created.' }
        format.json { render :show, status: :created, location: @datacast_account }
      else
        format.html { render :new }
        format.json { render json: @datacast_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /datacast_accounts/1
  # PATCH/PUT /datacast_accounts/1.json
  def update
    respond_to do |format|
      if @datacast_account.update(datacast_account_params)
        format.html { redirect_to @datacast_account, notice: 'Datacast account was successfully updated.' }
        format.json { render :show, status: :ok, location: @datacast_account }
      else
        format.html { render :edit }
        format.json { render json: @datacast_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /datacast_accounts/1
  # DELETE /datacast_accounts/1.json
  def destroy
    @datacast_account.destroy
    respond_to do |format|
      format.html { redirect_to datacast_accounts_url, notice: 'Datacast account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_datacast_account
      @datacast_account = DatacastAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def datacast_account_params
      params.require(:datacast_account).permit(:datacast_id, :account_id, :is_active)
    end
end
