#!/usr/bin/ruby
require "./src/constants.rb"

def get_abspath name
    File.absolute_path(name.to_s, REL_PATH)
end
