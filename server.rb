# frozen_string_literal: true

root = File.expand_path(File.join(__dir__, '.'))
$LOAD_PATH.unshift File.join(root, 'server')

Dir['server/**/*.rb'].each { |ruby_file| require_relative ruby_file }

require 'dotenv/load'
require 'pry' unless ENV['DEBUG'].nil?
