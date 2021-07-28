# frozen_string_literal: true

require 'coin_price'
require 'coingecko_ruby'
require 'thor'

module CoinPrice
  class CLI < Thor
    desc 'Get coin price by ids', 'xxx'
    def get(*ids)
      prices = client.price(ids)
      prices.each_key do |coin|
        puts "#{coin}: #{prices[coin]['usd']}"
      end
    end

    desc 'List all supported coins', 'xxx'
    def list
      client.coins_list.each do |coin_info|
        puts "[#{coin_info['symbol']}] - #{coin_info['id']}"
      end
    end

    private

    def client
      @client ||= CoingeckoRuby::Client.new
    end
  end
end
