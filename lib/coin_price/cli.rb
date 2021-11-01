# frozen_string_literal: true

require 'coin_price'
require 'coingecko_ruby'
require 'thor'

module CoinPrice
  class CLI < Thor
    desc 'Get coin price by ids', 'coin_price get bitcoin'
    def get(*ids)
      ids = default_coins if ids.empty?
      ids = correct_id_from_symbol(ids)
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

    def default_coins
      return 'bitcoin' if ENV['COIN_PRICE'].nil? || ENV['COIN_PRICE'].strip.empty?

      ENV['COIN_PRICE'].split(',')
    end

    def print_coin_info(coin_info)
      puts "[#{coin_info['symbol']}] - #{coin_info['id']}"
    end

    def client
      @client ||= CoingeckoRuby::Client.new
    end

    def all_coins
      @all_coins ||= client.coins_list
    end

    def correct_id_from_symbol(ids_or_symbols)
      ids_or_symbols.map do |id_or_symbol|
        cached_all_coins[id_or_symbol].nil? ? id_or_symbol : cached_all_coins[id_or_symbol]
      end
    end

    def cached_all_coins
      @cached_all_coins ||= begin
        data_from_file = read_cache_file
        data_from_file.each_with_object({}) do |coin_info, result|
          symbol, id = coin_info.split(',')
          result[symbol] = id
        end
      end
    end

    def read_cache_file
      begin
        File.read(cache_file_location).split("\n")
      rescue Errno::ENOENT
        cache_data_to_file
        retry
      end
    end

    def cache_data_to_file
      puts 'Caching ...'
      coins = all_coins.map do |coin_info|
        "#{coin_info['symbol']},#{coin_info['id']}"
      end
      File.open(cache_file_location, 'wb') { |f| f.puts(coins) }
    end

    def cache_file_location
      @cache_file_location ||= "#{Dir.home}/.coins.txt"
    end
  end
end
