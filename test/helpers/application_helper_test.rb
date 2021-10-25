require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'strip and squish whitespace' do
    leading_spaces_string = "    Hello"
    trailing_spaces_string = "World          "
    leading_and_trailing_spaces_string = "    Hello World        "
    squishable_string = "Hello         World"
    assert_equal "Hello", strip_and_squish_whitespaces(leading_spaces_string)
    assert_equal "World", strip_and_squish_whitespaces(trailing_spaces_string)
    assert_equal "Hello World", strip_and_squish_whitespaces(leading_and_trailing_spaces_string)
    assert_equal "Hello World", strip_and_squish_whitespaces(squishable_string)
  end

end