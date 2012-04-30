# Functions for testing simple_form custom inputs.
module InputsTestHelper
  include SimpleForm::ActionViewExtensions::FormHelper

  # Taken from simple_form/test/support/misc_helpers.rb
  def with_concat_form_for(*args, &block)
    concat simple_form_for(*args, &(block || proc {}))
  end

  # Taken from simple_form/test/support/misc_helpers.rb
  def with_input_for(object, attribute_name, type, options={})
    with_concat_form_for(object) do |f|
      f.input(attribute_name, options.merge(:as => type))
    end
  end
end
