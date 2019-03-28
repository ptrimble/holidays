require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/repository/custom_methods'

class CustomMethodsRepoTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::Definition::Repository::CustomMethods.new
  end

  def test_add_raises_error_if_input_is_nil
    assert_raise ArgumentError do
      @subject.add(nil)
    end
  end

  def test_add_raises_error_if_input_is_not_a_hash
    assert_raise ArgumentError do
      @subject.add(["test"])
    end
  end

  def test_find_returns_nil_if_method_id_does_not_exist
    assert_nil @subject.find("some-method-id")
  end

  def test_add_successfully_adds_new_custom_methods
    new_custom_methods = {
      "some-method-id" => Proc.new { |year|
        Date.civil(year, 1, 1)
      }
    }

    @subject.add(new_custom_methods)

    target_method = @subject.find("some-method-id")
    assert_equal new_custom_methods["some-method-id"], target_method
  end

  def test_add_raises_error_if_new_custom_method_already_exists
    custom_methods = {
      "some-method-id" => Proc.new { |year|
        Date.civil(year, 1, 1)
      }
    }

    @subject.add(custom_methods)
    target_method = @subject.find("some-method-id")
    assert_equal custom_methods["some-method-id"], target_method

    assert_raise ArgumentError do
      @subject.add(custom_methods)
    end
  end

  def test_add_raises_error_if_single_new_custom_method_in_multiple_new_methods_already_exists
    custom_methods = {
      "some-method-id" => Proc.new { |year|
        Date.civil(year, 1, 1)
      },
      "second-method-id" => Proc.new { |year|
        Date.civil(year, 2, 1)
      },
    }

    @subject.add(custom_methods)
    target_method = @subject.find("some-method-id")
    assert_equal custom_methods["some-method-id"], target_method

    target_method = @subject.find("second-method-id")
    assert_equal custom_methods["second-method-id"], target_method

    more_custom_methods = {
      "some-method-id" => Proc.new { |year|
        Date.civil(year, 1, 1)
      },
      "third-method-id" => Proc.new { |year|
        Date.civil(year, 2, 1)
      },
    }

    assert_raise ArgumentError do
      @subject.add(more_custom_methods)
    end
  end

  def test_add_successfullly_adds_multiple_new_custom_methods
    new_custom_methods = {
      "some-method-id" => Proc.new { |year|
        Date.civil(year, 1, 1)
      },
      "second-method-id" => Proc.new { |year|
        Date.civil(year, 1, 2)
      },
    }

    @subject.add(new_custom_methods)

    target_method = @subject.find("some-method-id")
    assert_equal new_custom_methods["some-method-id"], target_method

    target_method = @subject.find("second-method-id")
    assert_equal new_custom_methods["second-method-id"], target_method
  end

  def test_find_raises_error_if_target_method_id_is_nil_or_empty
    assert_raise ArgumentError do
      @subject.find(nil)
    end

    assert_raise ArgumentError do
      @subject.find("")
    end
  end
end
