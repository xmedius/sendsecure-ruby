module SendSecure
  class SendSecureException < Exception
    # code message
    # 0XX generic error code, when the server does not behave as expected
    #   1 unexpected server response format
    #
    # 1XX user token erro code
    # 100 unexpected user token error
    # 101 invalid permalink
    # 102 invalid credentials
    # 103 missing application_type parameter
    # 104 missing device_id parameter
    # 105 missing device_name parameter
    # 106 otp needed
    #
    # 404 not found
    # 500 unexpected error
    #
    attr_reader :code

    def initialize(msg = "unexpected server response format", code = "1")
      @code = code
      super(msg)
    end
  end

  class UnexpectedServerResponseException < SendSecureException; end

end
