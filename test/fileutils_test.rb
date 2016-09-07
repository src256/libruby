# coding: utf-8
require 'test_helper'

class FileUtilsTest < Minitest::Test
  include Libruby
  def test_which
    # macの場合
    path = FileUtils::which('more')
    assert_equal('/usr/bin/more', path)
  end
end
