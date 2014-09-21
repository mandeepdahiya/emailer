require 'mail'
require 'active_model'

class EmailSender
 include ActiveModel::Validations
 attr_accessor :from_email,:to_email,:subject, :message
 validates_presence_of :from_email, :to_email , :subject , :message
 validates :from_email,:to_email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
 def initialize from_email,to_email,subject,message
  @from_email  = from_email
  @to_email =  to_email
  @subject = subject
  @message  = message
 end

 def send_mail
  mail = Mail.new
  mail.to = self.to_email
  mail.from = self.from_email
  mail.subject = self.subject
  text_part = Mail::Part.new 
  text_part.body = self.message
  mail.text_part = text_part	
  mail.deliver!
  return true
 rescue Exception => e
   return false
 end

 def self.symbolize hash
  Hash[hash.map{|(k,v)| [k.to_sym,v]}]
 end
 email_config = YAML::load(File.open('email_config.yml'))
 email_config = symbolize(email_config)
 Mail.defaults do
  delivery_method :smtp,email_config
 end

 private_class_method :symbolize
 
end
