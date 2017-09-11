class Common_Word_Identifier
  def initialize
    in_file = File.open("common.txt", "r")
    @most_common_words = Array.new
    in_file.each_line { |line| @most_common_words.push(line.chomp.downcase) }
    in_file.close
    @most_common_words.sort
  end
  def is_common? word
    @most_common_words.include?  word
  end
end
