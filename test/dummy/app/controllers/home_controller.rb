class HomeController < ApplicationController
  def send_text_mail
    MyMailer.text_mail.deliver_now
    redirect_to root_path
  end

  def send_html_mail
    MyMailer.html_mail.deliver_now
    redirect_to root_path
  end

  def send_multipart_mail
    MyMailer.multipart_mail.deliver_now
    redirect_to root_path
  end
end
