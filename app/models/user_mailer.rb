class UserMailer < ActionMailer::Base
  def contact_submit(name, email, reason)
    recipients "youth10@youthsays.com"
    from       "dev@youthsays.com"
    subject    "[Contact form] New inquiries"
    sent_on    Time.now
    body       :name => name, :email => email, :reason => reason
  end

  def gathering_submit(name, email, link)
    recipients "youth10@youthsays.com"
    from       "dev@youthsays.com"
    subject    "[Gathering submit]"
    sent_on    Time.now
    body       :name => name, :email => email, :link => link
  end

  def volunteer_submit(name, email, reason)
    recipients "youth10@youthsays.com"
    from       "dev@youthsays.com"
    subject    "[Volunteer application]"
    sent_on    Time.now
    body       :name => name, :email => email, :reason => reason
  end

end
