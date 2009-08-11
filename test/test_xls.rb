$:.unshift(File.dirname(__FILE__)+'/../lib/')
require 'statsample'
require 'test/unit'
require 'tmpdir'
begin
	require 'spreadsheet'
rescue LoadError
	puts "You should install spreadsheet (gem install spreadsheet)"
end
class StatsampleExcelTestCase < Test::Unit::TestCase
	def initialize(*args)
        @ds=Statsample::Excel.read(File.dirname(__FILE__)+"/test_xls.xls")
		super
	end
    
    def test_read
        assert_equal(6,@ds.cases)
        assert_equal(%w{id name age city a1},@ds.fields)
        id=[1,2,3,4,5,6].to_vector(:scale)
        name=["Alex","Claude","Peter","Franz","George","Fernand"].to_vector(:nominal)
        age=[20,23,25,nil,5.5,nil].to_vector(:scale)
        city=["New York","London","London","Paris","Tome",nil].to_vector(:nominal)
        a1=["a,b","b,c","a",nil,"a,b,c",nil].to_vector(:nominal)
        ds_exp=Statsample::Dataset.new({'id'=>id,'name'=>name,'age'=>age,'city'=>city,'a1'=>a1}, %w{id name age city a1})
        ds_exp.fields.each{|f|
            assert_equal(ds_exp[f],@ds[f])
        }
        assert_equal(ds_exp,@ds)
        
    end
    def test_nil
        assert_equal(nil,@ds['age'][5])
    end
    def test_write
        filename=Dir::tmpdir+"/test_write.xls"
        Statsample::Excel.write(@ds,filename)
        ds2=Statsample::Excel.read(filename)
        i=0
        ds2.each_array{|row|
            assert_equal(@ds.case_as_array(i),row)
               i+=1
        }
    end
end