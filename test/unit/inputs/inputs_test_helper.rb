# Functions for testing simple_form custom inputs.
module InputsTestHelper

  class ActiveSupport::TestCase
    # Supports assert_select without having to render a view.
    # Usage:
    #   assert_select_in some_html 'ul#foo' do
    #     assert_select 'li.bar'
    #   end
    # See http://pastebin.com/uYrWigK7
    # See http://www.echographia.com/blog/2009/08/22/assert_select-from-arbitrary-text/
    # See https://github.com/vigetlabs/helper_me_test/blob/master/lib/helper_me_test.rb
    def assert_select_in(text, *args)
      @selected = HTML::Document.new(text).root.children
      assert_select(*args)
    end
  end

  include SimpleForm::ActionViewExtensions::FormHelper
end
