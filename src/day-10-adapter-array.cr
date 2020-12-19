require "option_parser"
require "benchmark"
require "string_scanner"

file_name = ""
benchmark = false

PREAMBLE = 25

OptionParser.parse do |parser|
  parser.banner = "Welcome to Report Repair"

  parser.on "-f FILE", "--file=FILE", "Input file" do |file|
    file_name = file
  end
  parser.on "-b", "--benchmark", "Measure benchmarks" do
    benchmark = true
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

unless file_name.empty?
  data_str = File.read_lines(file_name)
  data = [] of Int64
  data_str.each do |value|
    data << value.to_i64
  end

  data << 0
  data = data.sort
  data << data[-1] + 3


  difference = [0, 0, 0, 0]
  (1...data.size).each do |index|
    diff = data[index] - data[index-1]
    difference[diff] += 1
  end

  puts difference[1] * difference[3]

  previous = Array(Int64|Nil).new(data.size, nil)
  puts arrangements(data, 0, previous)

end

def arrangements(data : Array(Int64), index : Int64, previous : Array(Int64|Nil))
  return previous[index] if previous[index]
  total = 0_i64
  index_next = index + 1
  until (index_next >= data.size) || (data[index_next] > (data[index] + 3))
    total += 1 if (index_next == (data.size - 1))
    total += arrangements(data, index_next, previous).as(Int64)
    index_next += 1
  end
  previous[index] = total
  return total if total
  return 0
end

