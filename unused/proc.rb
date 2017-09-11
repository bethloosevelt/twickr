# encoding: UTF-8
in_file = File.open("out", 'r:UTF-8')
out_file = File.open("out2", "w:UTF-8")

in_file.each_line { |line|
  parts = line.split("=")
  word = parts[0]
  out_file.puts word + "|" + parts[1].split(/[^a-zA-Z]/).count.to_s
}


in_file.close
out_file.close
