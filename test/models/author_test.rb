# frozen_string_literal: true

require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test 'should be valid' do
    author = Author.new(name: 'Chetan Bhagat')
    assert author.valid?
  end

  test 'should not allow blank names' do
    author = Author.new(name: '')
    assert author.invalid?
  end
end
