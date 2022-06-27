require_relative "project"

class Module
  FUNCS = "lib/funcs.py"

  def get_funcs(name)
    func_path = get_abspath(FUNCS)
    value = %x(python #{func_path} #{name})
    return value
  end
end
