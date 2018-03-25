class JsonWebToken
  class << self
      def encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, 'super-secret')
      end
      def decode(token)
        JWT.decode(token, 'super-secret')
      end
  end
end
