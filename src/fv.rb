require_relative "python.rb"

class FV
  attr_reader :words

  WORDS = {
    :d => "def",
    :c => "class",
    :p => "p",
    :e => "end",
    :i => "<"
  }

  def self.d_def(row, name)
    self.add_brackets( row, name, Python::WORDS[:e] )
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

  def self.d_p(row)
    sym = FV::WORDS[:p]
    row = self.add_brackets( row, sym, ignore: true )
    row = row.sub( sym, Python::WORDS[:pr] )  # change word [p]
    row
  end

  def self.d_end(row, row_top)
    if row_top.include?( FV::WORDS[:d] ) ||
       row_top.include?( FV::WORDS[:c] )
      row.sub( FV::WORDS[:e], "".ljust(2) + Python::WORDS[:p] )
    else
      row.sub( FV::WORDS[:e], "" )
    end
  end

  def self.d_return(row)
    if !row.include?(FV::WORDS[:d]) &&
       !row.include?(FV::WORDS[:c]) &&
       !row.include?(Python::WORDS[:p]) &&
       !row.include?(Python::WORDS[:r]) &&
       !row.strip.empty?
      index = /[^ ]/ =~ row
      row[index] = "#{Python::WORDS[:r]} #{row[index]}"
      row
    else
      row
    end
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

  def initialize()
    @words = Array.new
  end

  def find_words(data)
    data.each_with_index do |row, i|
      FV::WORDS.each do |key, value|
        if row.include?(value)
          @words.append Word.new(value, row, i)
          break
        end
      end
  
      @words.each do |word|
        name = word.get_name
        if name
          if row.include?(name) &&
            !row.index(/['"].*?\b#{name}\b.*?['"]/) &&
            !row.include?(word.to_s)
            word.childs.append Word.new(name, row, i)
            break
          end
        end
      end
    end
  end
end