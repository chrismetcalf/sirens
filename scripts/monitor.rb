#!/usr/bin/env ruby

require 'rubygems'
require 'serialport'
require 'open-uri'
require 'json'
require 'yaml'

# How long to sleep between loops
sleep_time = 30

# Load config from a file
config = YAML::load(File.open(ARGV[0]))

sp = nil
sp = SerialPort.new config["serial_port"], 9600

while true do
  # Hudson checks
  hudson_down = false
  config["hudson_builds"].each do |build_url|
    begin
      open("#{build_url}/api/json") do |resp|
        results = JSON.parse(resp.read)

        if !results.nil? && (results["result"].nil? || results["result"] == "SUCCESS")
          puts "Hudson build #{build_url} is up or building..."
        else
          # FAIL!
          puts "Hudson build #{build_url} is DOWN!!!"
          hudson_down = true
        end
      end
    rescue Exception => e
      # Well, that didn't work...
      puts "Error accessing #{build_url}: #{e}"
      hudson_down = true;
    end
  end

  # Enable or disable lights
  sp.write(hudson_down ? "F" : "f")

  # Site checks
  site_down = false
  config["site_upness_urls"].each do |url|
    begin
      open(url) # If this doesn't throw an exception we're OK
      puts "URL #{url} appears to be up..."
    rescue Exception => e
      # Well, that didn't work...
      puts "Error accessing #{url}: #{e}"
      site_down = true
    end
  end

  # Enable or disable lights
  sp.write(site_down ? "D" : "d")

  sleep sleep_time
end
