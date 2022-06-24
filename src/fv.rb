class FV
  attr_reader :words

  WORDS = {
    :d => "def",
    :c => "class",
    :p => "p",
    :e => "end"
  }

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
            !row.include?(word.to_s)
            word.childs.append Word.new(name, row, i)
            break
          end
        end
      end
    end
  end
end