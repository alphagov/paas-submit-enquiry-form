require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
configure { set :server, :puma }

require './app'
run App
