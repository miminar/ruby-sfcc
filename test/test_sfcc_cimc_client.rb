require File.join(File.dirname(__FILE__), 'helper')
require 'pp'

class SfccCimcClient < SfccTestCase

  context "a running CIMOM with no auth" do
    setup do
    end

    should "be running" do
      assert cimom_running?
    end

    context "a new CIM environment" do
      setup do
        @env = Sfcc::Cimc::Environment.new("XML")
      end

      should "be of class Environment" do
        assert_kind_of(Sfcc::Cimc::Environment, @env)
      end

      context "a connection to the CIMOM" do
        setup do
          @client = @env.connect("localhost", "http", "5988", "root", "")
        end

        should "be of class Client" do
          assert_kind_of(Sfcc::Cimc::Client, @client)
        end
        
        context "a new object path for root/cimv2" do
          setup do
            @op = @env.new_object_path("root/cimv2", "")
          end

          should "be of class ObjectPath" do
            assert_kind_of(Sfcc::Cimc::ObjectPath, @op)
          end

          should "allow for query" do
            result = @client.query(@op, "select * from CIM_ComputerSystem", "wql")
            result.each do |instance|
              puts instance
            end
          end

          should "be able to get set properties using an object path" do
            @op = @env.new_object_path("root/cimv2", "Linux_ComputerSystem")
            @client.instance_names(@op).each do |path|
              puts path
              assert ! @client.property(@op, "Description").empty?
            end
            # @op.add_key("")
          end
          
          context "class names" do
            setup do
              @class_names = @client.class_names(@op, Sfcc::CIMC_FLAG_DeepInheritance)
            end

            should "be a Cimc::Enumeration" do
              assert_kind_of(Sfcc::Cimc::Enumeration, @class_names)
            end
            
            should "include CIM_ManagedElement" do
              assert !@class_names.select { |x| x.to_s == "CIM_ManagedElement" }.empty?
            end

            should "have every element of type Sfcc::Cimc::ObjectPath" do
              @class_names.each { |n| assert_kind_of(Sfcc::Cimc::ObjectPath, n) }
            end            
          end

          context "classes" do
            setup do
              @classes = @client.classes(@op, Sfcc::CIMC_FLAG_DeepInheritance)
            end

            should "be a Cimc::Enumeration" do
              assert_kind_of(Sfcc::Cimc::Enumeration, @classes)
            end

            should "have every alement of type Cimc::Class" do
              @classes.each { |c| assert_kind_of(Sfcc::Cimc::Class, c) }
            end            
          end

        end
        
      end
    end
    
  end  
end
