# frozen_string_literal: true

require 'coin_price'
require 'coingecko_ruby'
require 'thor'

module CoinPrice
  class CLI < Thor
    desc 'Get coin price by ids', 'coin_price get bitcoin'
    def get(*ids)
      if ids.empty?
        ids = ENV['COIN_PRICE'] || ['bitcoin']
      end
      prices = client.price(ids)
      prices.each_key do |coin|
        puts "#{coin}: #{prices[coin]['usd']}"
      end
    end

    desc 'List all supported coins', 'coin_price list'
    def list
      all_coins.each do |coin_info|
        print_coin_info(coin_info)
      end
    end

    desc 'Search coin list', 'coin_price search doge'
    def search(term)
      results = all_coins.select do |coin_info|
        coin_info['id'].include?(term) ||
          coin_info['symbol'].include?(term) ||
          coin_info['name'].include?(term)
      end
      results.each { |coin_info| print_coin_info(coin_info) }
    end

    private

    def print_coin_info(coin_info)
      puts "[#{coin_info['symbol']}] - #{coin_info['id']}"
    end

    def client
      @client ||= CoingeckoRuby::Client.new
    end

    def all_coins
      @all_coins ||= client.coins_list
    end
  end
end
