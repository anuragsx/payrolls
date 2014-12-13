class FeedbacksController < ApplicationController

  def new
    @feedback = Feedback.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feedback }
    end
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.user = @current_user
    respond_to do |format|
      if @feedback.save
        UserMailer.send_later(:deliver_feedback_thanks,@feedback)
        AdminMailer.send_later(:deliver_feedback_detail_to_admin,@feedback)
        flash[:notice] = "Feedback submit successfully."
        format.html { redirect_to root_path }
        format.js
        format.xml  { render :xml => @feedback, :status => :created, :location => @feedback }
      else
        flash[:error] = "Error in submitting feedback."
        format.html { render :action => "new" }
        format.js
        format.xml  { render :xml => @feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

end
