module ActionMessenger
  class Base
    # The message being built.
    attr_accessor :messages

    class << self
      def method_missing(method_symbol, *parameters) #:nodoc:
        case method_symbol.id2name
        when /^create_([_a-z]\w*)/ then new($1, *parameters).messages
        when /^send_([_a-z]\w*)/   then new($1, *parameters).send_messages
        end
      end           
    end
    
    def initialize(method_name = nil, *parameters) #:nodoc:
      create!(method_name, *parameters) if method_name
    end
    
    def create!(method_name, *parameters) #:nodoc:
      initialize_defaults
      send(method_name, *parameters)
      # TODO: Templates, ActionMailer-style.
      recipients.each do |r|
        message = Message.new
        message.to = r
        message.text = text_to_be_sent
        messages << message
      end
    end
    
    # Initialises default settings for this messenger.
    def initialize_defaults      
      @messages = []
      @recipients = []
      @text_to_be_sent = ''
    end

    def text_to_be_sent(parameters = nil)
      if parameters.blank?
        return @text_to_be_sent
      else
        @text_to_be_sent = parameters
      end
    end
    
    # Sets the recipients of the message being sent.
    #
    # If multiple recipients are specified, they will generally be sent as multiple
    # messages.
    def recipients(recipients = nil)
      unless recipients.nil?
        if recipients.is_a?(Array)
          @recipients += recipients
        else
          @recipients << recipients.to_s
        end
      end
      @recipients
    end
    
    # Sets a recipient.  Purely for readability if your app never sends the
    # same message to multiple recipients.
    def recipient(recipient)
      recipients(recipient)
    end   

    # Sends multiple messages.
    def send_messages
      messenger = Messengers::SalareeMessenger.new
      messages.map do |message|
        messenger.send_message(message.text,message.to)
      end
    end
  end
end
