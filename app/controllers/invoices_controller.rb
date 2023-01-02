class InvoicesController < ApplicationController
  before_action :find_invoice, only: %w[destroy xhr_change_client_name]

  def index
    @invoices = Invoice.all
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoices_path, notice: "Invoice created for #{@invoice.client_name}" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice.destroy!

    redirect_to invoices_path, notice: "Invoice for #{@invoice.client_name} successfully destroyed."
  end

  def xhr_change_client_name
    if request.get?
      render partial: 'modal--change-client-name', locals: { invoice: @invoice }
    elsif request.patch?
      @invoice.client_name = params[:invoice][:client_name]
      if @invoice.save
        render json: { id: @invoice.id, client_name: @invoice.client_name }
      else
        render json: @invoice.errors.full_messages.first
      end
    end
  end

  private

  def find_invoice
    @invoice = Invoice.find params[:id]
  end

  def invoice_params
    params.require(:invoice).permit(:client_name, :amount, :tax)
  end
end
