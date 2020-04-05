module Tribes
  class Headers
    def initialize
      @headers = {}
    end

    def set(header, value)
      @headers[header] = value
      self
    end

    def remove(header)
      @headers.delete(header)
    end

    def to_h
      @headers.to_h
    end
  end
end
