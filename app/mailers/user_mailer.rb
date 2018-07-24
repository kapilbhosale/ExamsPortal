class UserMailer < ApplicationMailer
  default from: 'ranjeet.jagtap43@gmail.com'
  layout 'mailer'

  def welcome_email
    @user = params[:user]
    @url  = 'https://smartexamrails.herokuapp.com/admin/sign_in'
    mail(to: @user.email, subject: 'Welcome to Smart Exam Site')
  end
end
