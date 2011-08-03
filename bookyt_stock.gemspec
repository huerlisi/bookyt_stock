# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'bookyt_stock/version'

Gem::Specification.new do |s|
  s.name         = "bookyt_stock"
  s.version      = BookytStock::VERSION
  s.authors      = ["Simon Hürlimann (CyT)"]
  s.email        = "simon.huerlimann@cyt.ch"
  s.homepage     = "https://github.com/huerlisi/bookyt_stock"
  s.summary      = "Stock plugin for bookyt"
  s.description  = "This plugin extends bookyt with asset/stock functionality."

  s.files        = `git ls-files app lib config`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
end
