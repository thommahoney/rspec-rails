module RSpec
  module Rails
    if defined?(ActiveRecord)
      module Extensions
        module ActiveRecord
          # Extension to enhance `should have` on AR Model classes
          #
          # @example
          #
          #     expect(ModelClass).to have(:no).records
          #     expect(ModelClass).to have(1).record
          #     expect(ModelClass).to have(n).records
          if ::Rails::VERSION::STRING > '4'
            def records
              all
            end
          else
            def records
              find(:all)
            end
          end
          alias :record :records
        end

        class ::ActiveRecord::Base
          extend RSpec::Rails::Extensions::ActiveRecord
        end
      end
    end
  end
end

if defined?(::ActiveModel)
  module ::ActiveModel::Validations
    # Extension to enhance `should have` on AR Model instances.  Calls
    # model.valid? in order to prepare the object's errors object. Accepts
    # a :context option to specify the validation context.
    #
    # You can also use this to specify the content of the error messages.
    #
    # @example
    #
    #     expect(model).to have(:no).errors_on(:attribute)
    #     expect(model).to have(1).error_on(:attribute)
    #     expect(model).to have(n).errors_on(:attribute)
    #     expect(model).to have(n).errors_on(:attribute, :context => :create)
    #
    #     expect(model.errors_on(:attribute)).to include("can't be blank")
    def errors_on(attribute, options = {})
      valid_args = [options[:context]].compact
      self.valid?(*valid_args)

      [self.errors[attribute]].flatten.compact
    end

    alias :error_on :errors_on
  end
end
