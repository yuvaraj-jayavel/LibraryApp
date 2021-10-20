# frozen_string_literal: true

require 'test_helper'

class PublisherTest < ActiveSupport::TestCase
  test 'should be valid' do
    publisher = Publisher.new(name: 'Chetan Bhagat')
    assert publisher.valid?
  end

  test 'should not allow blank names' do
    publisher = Publisher.new(name: '')
    assert publisher.invalid?
  end
end
