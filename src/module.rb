require_relative "project"
require "json"
require 'singleton'

class Module
  include Singleton
  attr_reader :functions

  FUNCS = "lib/funcs.py"
  MODULES = {
    b: "builtins"
  }
  VALIED = {
    b: "builtin_function_or_method",
    f: "function"
  }

  def self.get_module_data(name)
    func_path = get_abspath(FUNCS)
    value = %x(python #{func_path} #{name})
    return value
  end

  def self.get_funcs(name)
    json = self.get_module_data(name)
    json_obj = JSON.parse(json)
    json_obj["#{name}"].select do |f|
      type_name = f["type"]["name"]
      !Module::VALIED.select{ |k, v| v == type_name }.empty?
    end
  end

  def initialize
    @functions = Hash.new
    init_modules_functions()
  end

  def init_module_functions(name)
    funcs = Module::get_funcs(name)
    funcs.each do |v|
      n = v["name"]
      @functions["#{name}.#{n}"] = n
    end
  end

  private
  def init_modules_functions
    Module::MODULES.each do |k, v|
      init_module_functions(v)
    end
  end
end
