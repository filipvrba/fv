def get_abspath(value)
    path = File.realpath( '../..', __FILE__ )
    return File.join( path, value )
end