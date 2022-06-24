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
end