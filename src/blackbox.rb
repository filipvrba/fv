#!/usr/bin/ruby

require 'json'
require './src/constants.rb'
require "./src/project.rb"

class Blackbox

    def initialize
        @abspath = get_abspath BLACKBOX + P_JSON
        @hash = {}
        open
    end

    def add pid, name
        @hash[pid.to_s] = name.to_s
        save
    end

    def save
        File.open(@abspath, mode="w+") do |f|
            f.write JSON.pretty_generate @hash
        end
    end

    def open
        if File.exist? @abspath
            @hash = JSON.load_file @abspath
        else
            save
        end
    end

    def free pid
        @hash.delete pid.to_s
        save
    end
end
