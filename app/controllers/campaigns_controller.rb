class CampaignsController < ApplicationController

  before_filter :authenticate_user, except:[:show, :index]

  require 'wikipedia'
  def index
    @campaigns = Campaign.all
    @campaign = Campaign.new
    @markers = [{}].to_json
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
    @operations = @campaign.operations.includes(:events)
    @markers = @campaign.events.to_gmaps4rails

    respond_to do |format|
      format.html
      format.json { render json: @operations }
    end
  end

  # GET /campaigns/new
  # GET /campaigns/new.json
  def new
    @campaign = Campaign.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @campaign }
      format.js
    end
  end

  # GET /campaigns/1/edit
  def edit
    @campaign = Campaign.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(params[:campaign])

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to campaigns_path, notice: 'Campaign was successfully created.' }
        format.json { render json: @campaign, status: :created, location: @campaign }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /campaigns/1
  # PUT /campaigns/1.json
  def update
    @campaign = Campaign.find(params[:id])

    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to campaigns_url }
      format.json { head :no_content }
      format.js
    end
  end
end
