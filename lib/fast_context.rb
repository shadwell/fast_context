require 'shoulda/context'

module ShouldaContextExtensions
  def fast_context(name, &blk)
    @fast_subcontexts ||= []
    @fast_subcontexts << Shoulda::FastContext.new(name, self, &blk)
  end

  def build
    super
    @fast_subcontexts ||= []
    @fast_subcontexts.each {|f| f.build }
  end

  def am_subcontext?
    parent.is_a?(Shoulda::Context::Context) || parent.is_a?(Shoulda::FastContext)
  end
end

module Shoulda
  class FastContext < Context::Context
    def test_method_name
      joined_should_name = shoulds.collect{ |should_hash| should_hash[:name] }.join(' and ')
      test_name = ["test", full_name, "should", joined_should_name].flatten.join('_')
      test_name = test_name.gsub(' ', '_').gsub(/[^a-zA-Z0-9_?!]/, '').gsub(/__+/, '_').to_sym
      return test_name
    end

    def create_test_from_should_hash
      test_name = test_method_name

      if test_unit_class.instance_methods.include?(test_name.to_s)
        warn "  * WARNING: '#{test_name}' is already defined"
      end

      context = self
      test_unit_class.send(:define_method, test_name) do
        @shoulda_context = context
        @current_should = nil
        begin
          context.run_parent_setup_blocks(self)
          context.shoulds.each do |s|
            @current_should = s
            s[:before].bind(self).call if s[:before]
          end
          context.run_current_setup_blocks(self)

          context.shoulds.each {|should| should[:block].bind(self).call }
        rescue => e
          if defined?(Test::Unit::AssertionFailedError) && e.kind_of?(Test::Unit::AssertionFailedError)
            error = Test::Unit::AssertionFailedError.new(["FAILED:", context.full_name, "should", "#{@current_should[:name]}:", e.message].flatten.join(' '))
            error.set_backtrace e.backtrace
            raise error
          else
            raise e
          end
        ensure
          context.run_all_teardown_blocks(self)
        end
      end
    end

    def build
      create_test_from_should_hash
      subcontexts.each {|context| context.build }

      @fast_subcontexts ||= []
      @fast_subcontexts.each {|f| f.build }

      print_should_eventuallys
    end
  end
end

class ActiveSupport::TestCase
  def self.fast_context(name, &blk)
    if Shoulda::Context.current_context
      Shoulda::Context.current_context.fast_context(name, &blk)
    else
      context = Shoulda::FastContext.new(name, self, &blk)
      context.build
    end
  end
end

Shoulda::Context::Context.send :prepend, ShouldaContextExtensions
