class MyMailer < ApplicationMailer
  def text_mail
    mail(to: "alessandro.rodi@renuo.ch", subject: "Text mail")
  end

  def html_mail
    mail(to: "alessandro.rodi@renuo.ch", subject: "HTML mail")
  end

  def multipart_mail
    mail(to: "alessandro.rodi@renuo.ch", subject: "Multipart mail")
  end
end
