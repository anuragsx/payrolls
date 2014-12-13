module ActionMessenger
  module Messengers
    class SalareeMessenger #< ActionMessenger::Messenger

      def initialize
        @config_file = RAILS_ROOT + "/config/messenger.yml"
        @config_file = YAML.load_file(@config_file)        
        @address = @config_file['address']
        @uname = @config_file['uname']
        @passwd = @config_file['passwd']
        @sender = @config_file['sender']
        @client = Net::HTTP
      end
      
      # Sends a message.
      def send_message(message, to)
        raise "no no mobile number object available for delivery!" unless to
        begin
          @client.post_form(URI.parse(@address),
            { :text => message, :PhoneNumber => format_number(to),
              :uname => @uname, :passwd => @passwd, :sender => @sender })
        rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
            Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        end
      end

      private

      def format_number(number)
        # Remove + sign and all spaces from the number
        number.gsub(/[\s+]*/,'')
      end
    end
  end
end