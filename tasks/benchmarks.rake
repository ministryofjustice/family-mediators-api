require 'benchmark'
require_relative '../lib/admin/processing/practice_parser'

desc "Benchmark various parts of the system"
task :benchmarks do

  ITERATIONS = 100_000
  DATA = '1 Null Way, Wessex        CM2 9AF: 01245 605040 :foo@bar.com:http://www.foobar.com/baz/
Bish Road, Boshtown  NN17 1TY: 01536 276727:bish@bosh.co.uk:
-2 Bonkers Blvd, Freaksville  SW19 5EG:2089445290:bonkers@geesh.co.uk
949 Bloopers Blvd, Normalville  TS1 2RQ
23450235608236
BN2 0GB
andy@andywhite.org'

  Benchmark.bm(50) do |bm|
    bm.report "PracticeParser: #{ITERATIONS} iterations, #{DATA.split("\n").size} practices" do
      ITERATIONS.times do
        Admin::Processing::PracticeParser.parse(DATA)
      end
    end
  end

end
