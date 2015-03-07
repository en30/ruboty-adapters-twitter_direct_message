require 'ruboty'
require 'mem'
require 'twitter'
require 'active_support/inflector'

module Ruboty
  module Adapters
    class TwitterDirectMessage < Base
      include Mem

      VERSION = Gem.loaded_specs[name.underscore.tr('/', '-')].version.to_s.freeze
      SMALL_WHITE_SPACE_EMOJI = "\xE2\x96\xAB"

      env :TWITTER_ACCESS_TOKEN, 'Twitter access token'
      env :TWITTER_ACCESS_TOKEN_SECRET, 'Twitter access token secret'
      env :TWITTER_CONSUMER_KEY, 'Twitter consumer key (a.k.a. API key)'
      env :TWITTER_CONSUMER_SECRET, 'Twitter consumer secret (a.k.a. API secret)'

      def run
        Thread.abort_on_exception = true
        listen
      end

      def say(message)
        split_for_tweet(message[:body]).each do |msg|
          utter msg, target: message[:original][:from]
        end
      end

      private

      def listen
        stream.user do |message|
          if message.is_a? ::Twitter::DirectMessage
            robot.receive(
              body: message.text,
              from: message.sender.screen_name
            )
          end
        end
      end

      def configure
        proc do |config|
          config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
          config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
          config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
        end
      end
      memoize :configure

      def client
        ::Twitter::REST::Client.new(&configure)
      end
      memoize :client

      def stream
        ::Twitter::Streaming::Client.new(&configure)
      end
      memoize :stream

      def split_for_tweet(text)
        text.scan(/(?:\S{100,140}(?=\r?\n)|\S{120,140}(?=\s)|.{1,140})/)
      end

      def utter(text, target: , limit: 5)
        client.create_direct_message(target, text)
      rescue ::Twitter::Error => e
        if e.message.include?('You already said that') and limit > 1
          # twitter ignores normal white spaces
          utter(text << SMALL_WHITE_SPACE_EMOJI, target: target, limit: limit - 1)
        else
          Ruboty.logger.error(e)
        end
      end
    end
  end
end
