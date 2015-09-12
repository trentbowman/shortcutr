require 'test_helper'

class ShortcutTest < ActiveSupport::TestCase

	test "target can be valid" do
		Shortcut.create(url: 'http://somewhere.org', target: '456def')
		shortcut = Shortcut.new(url: 'http://somewhereelse.org', target: '123abc')
		assert shortcut.valid?, shortcut.errors
	end

	test "target must be unique" do
		Shortcut.create(url: 'http://somewhere.org', target: '123abc')

		shortcut = Shortcut.new(url: 'http://somewhereelse.org', target: '123abc')

		assert_not shortcut.valid?, "shortcut should not be valid"
		assert_includes shortcut.errors.messages[:target], "has already been taken"

	end

	test "target must be present" do
		[nil, ''].each do |target|
			shortcut = Shortcut.new(url: 'http://somewhereelse.org', target: target)

			assert_not shortcut.valid?, "shortcut should not be valid"
			assert_includes shortcut.errors.messages[:target], "can't be blank"
		end
	end

	test "target must be 6 characters long" do
		shortcut = Shortcut.new(url: 'http://somewhereelse.org', target: '123345677dcd')

		assert_not shortcut.valid?, "shortcut should not be valid"
		assert_includes shortcut.errors.messages[:target], "is the wrong length (should be 6 characters)"
	end

	test "target cannot contain disallowed words" do
		%w[123foo 123bar barabc fooabc].each do |target|
			shortcut = Shortcut.new(url: 'http://somewhereelse.org', target: target)

			assert_not shortcut.valid?, "shortcut with target #{target} should not be valid"
			assert_includes shortcut.errors.messages[:target], "contains a bad word"
		end
	end

	test "target must be sufficiently distinct" do
		Shortcut.create(url: 'http://somewhere.org', target: '123abc')

		%w[z23abc 1z3abc 12zabc 123zbc 123azc 123abz].each do |target|
			shortcut = Shortcut.new(url: 'http://somewhereelse.org', target: target)

			assert_not shortcut.valid?, "shortcut with target #{target} should not be valid"
			assert_includes shortcut.errors.messages[:target], "is not sufficiently distinct"
		end

		%w[z23abz 1z3azc 12zzbc].each do |target|
			shortcut = Shortcut.new(url: 'http://somewhereelse.org', target: target)

			assert shortcut.valid?, "shortcut with target #{target} should be valid"
		end

	end

	test "shortcut is not assigned a target if it already has one" do
		shortcut = Shortcut.new(url: 'http://somewhere.org', target: '123abc')

		shortcut.save!

		assert_equal '123abc', shortcut.target
	end

	test "random target is 6 characters long" do
		target = Shortcut.random_target

		assert_equal 6, target.length
	end

	test "random target contains only allowed digits" do
		# We can't test all of the random targets, but we can test 10 of them
		10.times do
			target = Shortcut.random_target

			target.chars.each do |digit|
				assert Shortcut::DIGITS.include?(digit), "#{target} includes illegal character #{digit}"
			end
		end
	end

	test "normalize_target" do
		assert_equal 'h2rq81', Shortcut.normalize_target('h2rq8l')
		assert_equal 'h2rq80', Shortcut.normalize_target('h2rq8o')
		assert_equal 'h2rq80', Shortcut.normalize_target('h2rq8O')
	end

	test "hamming_distance" do
		assert_equal 0, Shortcut.hamming_distance('123abc', '123abc')
		assert_equal 1, Shortcut.hamming_distance('123abc', '123abz')
		assert_equal 1, Shortcut.hamming_distance('123abc', '123azc')
		assert_equal 1, Shortcut.hamming_distance('123abc', '123zbc')
		assert_equal 1, Shortcut.hamming_distance('123abc', '12zabc')
		assert_equal 1, Shortcut.hamming_distance('123abc', '1z3abc')
		assert_equal 2, Shortcut.hamming_distance('123abc', '1zxabc')
		assert_equal 3, Shortcut.hamming_distance('123abc', 'yzxabc')
	end

  # test "the truth" do
  #   assert true
  # end
end
