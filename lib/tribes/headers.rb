# frozen_string_literal: true

module Tribes
  class Headers
    def initialize
      @headers = {
        # 'Accept-Encoding' => 'deflate, gzip',
        'User-Agent' => 'Mozilla/5.0 (Android; U; pl-PL) AppleWebKit/533.19.4 (KHTML,like Gecko) AdobeAIR/31.0',
        'x-flash-version' => '31,0,0,101',
        'Connection' => 'Keep-Alive',
        'Cache-Control' => 'no-cache',
        'Referer' => 'app:/staemme.swf',
        'Content-Type' => 'flv-application/octet-stream; charset=UTF-8',
        'x-ig-os-name' => 'android',
        'x-ig-os-version' => '5.0',
        'x-ig-model' => 'HTC One',
        'x-ig-manufacturer' => 'HTC',
        'IGMobileDevice' => 'Android'
      }
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
