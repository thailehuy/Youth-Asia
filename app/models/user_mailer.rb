class UserMailer < ActionMailer::Base
  def contact_submit(name, email, reason)
    recipients "thailehuy@yahoo.com"
    from       "chip@youthasia.com"
    subject    "New inquiries"
    sent_on    Time.now
    body       :name => name, :email => email, :reason => reason
  end

end
