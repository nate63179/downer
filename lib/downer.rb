require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'optparse'
require 'open-uri'

Dir.glob(File.dirname(__FILE__) + '/**/*.rb').each { |file| require file }