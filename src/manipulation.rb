require_relative "python"

class Manipulation
  def self.d_def(row, name)
    row = self.add_brackets( row, name, Python::WORDS[:e] )
    self.d_special_def( row, name )
  end

  def self.d_p_def(parent, row, name)
    if parent && parent == FV::BLOCKS[:c]
      comma = row.index( /(#{name}){1}( |:)?(:)/ ) ? "" : ","
      row = row.sub( name, "#{name} self#{comma}" )
    end

    self.d_def( row, name )
  end

  def self.d_special_def(row, name)
    is_special = name.index( /^__/ ) && name.each_char
      .with_object(Hash.new(0)) {|c, m| m[c]+=1}["_"] == 2
    
    if is_special
      row.sub(name, name + "_" * 2)
    else
      row
    end
  end

  def self.d_inheritance(row)
    sym = FV::WORDS[:i]
    if row.include?(sym)
      row = row.sub(sym, "")
    end

    row
  end

  def self.d_class(row, name)
    sym = "\n"
    if row.include?( Python::WORDS[:e] )
      sym = Python::WORDS[:e]
    end

    row = self.add_brackets( row, name, sym )
    row = FV.d_inheritance(row)
    row
  end

  def self.d_if(rows, index)
    r_u = rows[index]
    r_d = rows[index + 1]
    row = r_u

    if r_d
      r_u_e = !FV::CONTROLS.select { |k, v| r_u.include?( v ) }.empty?
      r_d_e = !FV::CONTROLS.select { |k, v| r_d.include?( v ) }.empty?
      if r_u_e and r_d_e
        row += "".ljust(2) + Python::WORDS[:p] + "\n"
      end
    end

    return row
  end

  def self.d_p(row)
    sym = FV::WORDS[:p]
    row = self.add_brackets( row, sym, ignore: true )
    row = row.sub( sym, Python::WORDS[:pr] )  # change word [p]
    row
  end

  def self.d_end(row, row_top)
    words = [ FV::BLOCKS[:d], FV::BLOCKS[:c], FV::CONTROLS[:i],
              FV::CONTROLS[:e], FV::CONTROLS[:ei] ]

    if !words.select { |w| row_top.include?( w ) }.empty?
      row.sub( FV::BLOCKS_END[:e], "".ljust(2) + Python::WORDS[:p] )
    else
      row.sub( FV::BLOCKS_END[:e], "" )
    end
  end

  def self.d_main()
    "\nif __name__ == \"__main__\":\n  main()\n"
  end

  def self.d_nil(row)
    row.gsub( FV::VARIABLES[:n], Python::WORDS[:n] )
  end

  def self.d_false(row)
    row.gsub( FV::VARIABLES[:f], Python::WORDS[:f] )
  end

  def self.d_true(row)
    row.gsub( FV::VARIABLES[:t], Python::WORDS[:t] )
  end

  def self.d_other(row, name)
    self.add_brackets( row, name )
  end

  def self.add_brackets(row, name, value = "\n", ignore: ignore = false)
    if row.index(/[()]/) and !ignore
      return row
    end

    s_i = row.index(name) + name.length
    row[s_i] = "(#{row[s_i]}"
    row = row.sub(value, ")#{value}")
    return row
  end

  def self.overwrite( str, str_two )
    str.tap{ |r| r[0, str_two.length] = str_two[0, r.length]}
  end
end