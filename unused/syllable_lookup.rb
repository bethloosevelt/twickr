
require_relative "config"

class Syllable_Table
  def initialize
    @word_entry = Struct.new(:word, :syllable_count)
    @table = Array.new
    words_file = File.open(Config[:Words_File_Path], "r")
    words_file.each_line { |line|
      parts = line.split("|")
      @table.push(@word_entry.new(parts[0], parts[1].to_i))
    }
  end
  def lookup_word word
    word = @table.bsearch { |entry|
      word <=> entry.word
    }
    return word ? word.syllable_count : 0
  end
end
