module ActionMessenger
  # A message which will be sent, or which has been received.
  class Message
    
      # The recipient of the message.
    attr_accessor :to, :text

    # Compares this object with another for equality.
    #
    # The other object is considered equal if it is not <code>nil</code> and all its fields
    # are the same as this object's fields.
    def ==(that)
      return false if that.nil?
      to == that.to 
    end
  end
end
