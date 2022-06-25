class Word
  attr_reader :row, :childs, :index
  attr_writer :row

  def initialize(word, row, index)
    @word = word
    @row = row
    @index = index
    @childs = Array.new
  end

  def get_name
    s = @row.split(' ')
    return s.length > 1 ? s[1].sub(":", "") : nil
  end

  def to_s
    @word
  end
end