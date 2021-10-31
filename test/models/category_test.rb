# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'should be valid' do
    category = Category.new(name: 'Chetan Bhagat')
    assert category.valid?
  end

  test 'should not allow blank names' do
    category = Category.new(name: '')
    assert category.invalid?
  end
end
