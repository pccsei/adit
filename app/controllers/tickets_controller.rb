require 'common_methods'
class TicketsController < ApplicationController
  include CommonMethods

  def index
    @tickets = Ticket.all
  end

  def show
  end

  def new
    @ticket = Ticket.new
  end

  def create
    clients = Client.all
    clients.each do |c|
       ticket = c.tickets.create(
         project_id: get_current_project,
         priority_id: 2) # Will need a method to calculate)
       ticket.save
    end
    respond_to do |format|
        format.html { redirect_to tickets_url, notice: 'Ticket was successfully created.' }
    end
  end

  def update
    respond_to do |format|
      if @ticket.update(project_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url }
    end
  end
  
  private
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:id, :sale_value, :page_size, :created_at, :updated_at, :payment_type, :attachment, :attachment_name, :project_id, :client_id, :user_id, :priority_id)
    end
end