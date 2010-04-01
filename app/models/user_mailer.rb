class UserMailer < ActionMailer::Base
  def contact_submit(name, email, reason)
    recipients "youth10@youthsays.com"
    from       "dev@youthsays.com"
    subject    "[Contact form] New inquiries"
    sent_on    Time.now
    body       :name => name, :email => email, :reason => reason
  end

  def gathering_submit(gathering)
    recipients "youth10@youthsays.com"
    from       "dev@youthsays.com"
    subject    "[Gathering submit]"
    sent_on    Time.now
    body       :name => gathering.name, 
                :email => gathering.email, :link => gathering.event_link,
                :phone => gathering.phone, :ic_number => gathering.ic_number
  end

  def volunteer_submit(volunteer)
    recipients "youth10@youthsays.com"
    from       "dev@youthsays.com"
    subject    "[Volunteer application]"
    sent_on    Time.now
    body       :name => volunteer.name,
                :email => volunteer.email,
                :phone => volunteer.phone, :ic_number => volunteer.ic_number,
                :reason => volunteer.reason
  end

  def story_submit(name, story)
    recipients "youth10@youthsays.com"
    from       "dev@youthsays.com"
    subject    "[Story submitted]"
    sent_on    Time.now
    body       :name => name,
                :story => story.content
  end
end
