require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
#require 'pp'

class SfccCimcType < SfccTestCase

  context "a Cim::Class representation" do
    setup do
      setup_cim_client
      op = Sfcc::Cim::ObjectPath.new("root/cimv2", "CIM_ComputerSystem")
      @cimclass = @client.get_class(op)
    end
    
    should "provides Cim::Type for all its properties" do
      @cimclass.each_property do |k, d|
        assert_kind_of(Sfcc::Cim::Type, d.type)
      end
    end
    
    should "have string and Integer representations of Cim::Type for all its properties" do
      @cimclass.each_property do |k, d|
        assert_kind_of(String, d.type.to_s)
        assert_kind_of(Integer, d.type.to_i)
        if d.type.to_s =~ /\[\]/
          assert d.type.array?
        else
          assert !d.type.array?
          assert d.type.integer? if d.type.to_s =~ /int/
          assert d.type.real? if d.type.to_s =~ /real/
          assert d.type.string? if d.type.to_s =~ /string/
        end
      end
    end
    
  end
  
end
