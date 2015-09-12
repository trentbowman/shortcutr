class Shortcut < ActiveRecord::Base

	# The canonical digits. Hopefully none of these can be easily
	# confused. 
	DIGITS = 	%w[0 1 2 3 4 5 6 7 8 9] +
				%w[a b c d e f g h j k] +
				%w[m n p q r s t u w x] +
				%w[y z]

	BAD_WORDS = %w[foo bar]

	scope :with_normalized_target, -> (target) { where(:target => normalize_target(target)) }

	validates :target, uniqueness: true, presence: true, length: { is: 6 } 
	validate :target_is_sufficiently_distinct, :target_has_no_bad_words

	def to_param
	  target
	end

	# Assigns this shortcut a target if it doesn't already have one
	def assign_target
		# TODO This target may not be unique or sufficiently different from other targets.
    	# We need to roll another one if necessary
		self.target = Shortcut.random_target unless target.present?
	end

	# Validates that target is at least 2 digits different from all other
	# shortcuts
	def target_is_sufficiently_distinct

		return unless target.present? && target.length == 6

		# TODO: don't use brute force
		# Idea: Cache the the sum of all the digits in a column. Then,
		#  find shortcuts where digit_sum is less than 32 of this instance's digit_sum.
		# Idea: Some kind of 6-dimensonial geospatial index, one for each digit?
		other_targets = Shortcut.all.pluck(:target)
		other_targets.each do |other_target|
			if Shortcut.hamming_distance(target, other_target) <= 1
				errors[:target] << "is not sufficiently distinct"
				return
			end
		end
	end

	def target_has_no_bad_words

		return unless target.present?

		BAD_WORDS.each do |word|
			if target.include?(word)
				errors[:target] << "contains a bad word"
				return
			end
		end				
	end

	def short_url
		Rails.application.routes.url_helpers.api_url(target)
	end

	# TODO: move these to lib

	# Produces a random 6-digit string containing only canonical digits
	# Since each digit has 32 possibilities, and we have 6 digits,
	# this essentailly is a 30-bit (log2(32) * 6) integer.
	def self.random_target
		6.times.map{|e| DIGITS.sample}.join
	end

	# Converts commonly confused digits to canonical digits
	# TODO: lowercase?
	def self.normalize_target target
		target.gsub(/[Oo]/, '0').gsub(/l/, '1')
	end

	# Calculates the number of digits in which left and right differ.
	# Left and right must be of equal length
	def self.hamming_distance(left, right)
		raise ArgumentError, "arguments not of equal length" unless left.length == right.length
		left.chars.zip(right.chars).map do |l, r|
			l == r ? 0 : 1
		end.sum
	end

end
