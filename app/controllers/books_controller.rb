class BooksController < ApplicationController

  include ApplicationHelper

  def index
    @book_events = Event.joins(:books).where(books:{user_id:current_user.id})
    @book_events = @book_events.page(params[:page])
  end

  def new
    @event = Event.find(params[:book][:event_id])
    @user = current_user
    @total_price =  @event.price
  end

  def create
    @event = Event.find(params[:book][:event_id])
    @book = current_user.books.build(book_params)

    # Find the user to pay.
    user = @event.user

    # Charge
    amount = params[:book][:price]

    #有料のイベントのstripeで代金の処理をする
    if amount.to_i > 0
      #fee
      fee = (amount.to_i * 0.1).to_i

      # Calculate the fee amount that goes to the application.
      # docs https://stripe.com/docs/connect/payments-fees
      begin
        charge_attrs = {
          amount: amount,
          currency: user.currency,
          source: params[:token],
          description: "Test Charge via Stripe Connect",
          application_fee: fee
        }

        # Use the platform's access token, and specify the
        # connected account's user id as the destination so that
        # the charge is transferred to their account.
        charge_attrs[:destination] = user.stripe_user_id

        charge = Stripe::Charge.create( charge_attrs )

        #have to edit view template to show html in flash
        flash[:notice] = "Charged successfully!"

      rescue Stripe::CardError => e
        error = e.json_body[:error][:message]
        flash[:error] = "Charge failed! #{error}"
      end
    end

    #if @book.save!

      ##############################################################################################
      #並列処理に移動する
      booked_user_name = get_user_name(current_user.id)
      recipient_user_email = get_user_email_by_id(current_user.id)
      title = get_event_title(@book.event_id)
      url = root_url + 'users/sign_in'
      #url = 'https://connect-holiday.herokuapp.com/users/sign_in'


      NoticePlannerMailer.delay.notice_planner_email(recipient_user_email, booked_user_name, title, url)
      #NoticePlannerMailer.notice_planner_email(recipient_user_email, booked_user_name, title, url).deliver_later
      ##############################################################################################

      flash[:info] = 'イベントに参加申請をしました。'
      redirect_to event_path(@book.event_id)
    #else
    #  render action: "show"
    #end
  end

  private

  def book_params
    params.require(:book).permit(:event_id, :user_id)
  end
end
