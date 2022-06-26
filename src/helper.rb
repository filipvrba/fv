def p_header(name)
  identation = 10
  puts "=" * identation + name + "=" * identation 
end

def p_dev( fv, is_dev = false )
  if not is_dev
    return
  end

  p_header("Python")
  puts fv.data
  p_header("App")
end