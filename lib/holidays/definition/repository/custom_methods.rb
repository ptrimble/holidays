module Holidays
  module Definition
    module Repository
      #FIXME I believe I am going to have to make this more robust and store the region along with
      #      the custom method. I think it either needs A) to be a optional field that can be passed
      #      when searching or B) make the 'common' ones have a unique 'common' region that is hardcoded
      #      somehow. Leaning towards option A...
      class CustomMethods
        def initialize
          @custom_methods = {}
        end

        def add(new_custom_methods)
          raise ArgumentError unless new_custom_methods && new_custom_methods.is_a?(Hash)

          #TODO We should be checking for conflicts and raising an error if it happens. This is
          #     the only way we will be able to avoid the scenario that started this whole deep dive.
          #     It should not be possible for one definition to in any way overwrite already-loaded
          #     custom methods from another source.
          #if conflict = new_custom_methods.detect { |k, v| @custom_methods.include?(k) }
          #  raise ArgumentError.new("Error adding custom method with id '#{conflict.first}', method with identical ID already added!")
          #end

          # Example of final desired output:
          #
          # {
          #   "easter(year)"=>#<Proc:0x00007fc2470aff80 (lambda)>,
          #   "orthodox_easter(year)"=>#<Proc:0x00007fc2470afeb8 (lambda)>,
          #   "orthodox_easter_julian(year)"=>#<Proc:0x00007fc2470afdc8 (lambda)>,
          #   "to_monday_if_sunday(date)"=>#<Proc:0x00007fc2470afd00 (lambda)>,
          #   "to_monday_if_weekend(date)"=>#<Proc:0x00007fc2470afc38 (lambda)>,
          #   "to_weekday_if_boxing_weekend(date)"=>#<Proc:0x00007fc2470afb70 (lambda)>,
          #   "to_weekday_if_boxing_weekend_from_year(year)"=>#<Proc:0x00007fc2470afaa8 (lambda)>,
          #   "to_weekday_if_weekend(date)"=>#<Proc:0x00007fc2470af9e0 (lambda)>,
          #   "calculate_day_of_month(year, month, day, wday)"=>#<Proc:0x00007fc2470af918 (lambda)>,
          #   "to_weekday_if_boxing_weekend_from_year_or_to_tuesday_if_monday(year)"=>#<Proc:0x00007fc2470af850 (lambda)>,
          #   "to_tuesday_if_sunday_or_monday_if_saturday(date)"=>#<Proc:0x00007fc2470af788 (lambda)>,
          #   "lunar_to_solar(year, month, day, region)"=>#<Proc:0x00007fc2470af6c0 (lambda)>,
          #
          #   # These are the custom ones loaded from the test file
          #   "conflict_custom_method_1(year)"=>#<Proc:0x00007fc248a266a8@(eval):1>,
          #   "conflict_custom_method_identical_name_between_regions(year)"=> {
          #      :multiple_with_conflict_1 => #<Proc:0x00007fc2489f47c0@(eval):1>,
          #      :multiple_with_conflict_2 => #<Proc:0x00007fc2489f412e@(eval):1>,
          #    },
          #   "conflict_custom_method_identical_name_between_regions_but_different_holiday_names(year)"=> {
          #     :multiple_with_conflicts_1 => #<Proc:0x00007fc248a07a78@(eval):1>,
          #     :multiple_with_conflicts_2 => #<Proc:0x00007fc248a07bf2@(eval):1>,
          #   },
          #   "conflict_custom_method_2(year)"=>#<Proc:0x00007fc2489f59e0@(eval):1>,
          # }
          #
          # When adding we need to do the following:
          #
          # 1) If no matching ID then just add it
          # 2) If matching ID then check whether the desired regions are present:
          #    2a) If it already exists return an error, conflict!
          #    2b) If it doesn't then add it and the proc
          @custom_methods.merge!(new_custom_methods)
        end

        def find(method_id)
          raise ArgumentError if method_id.nil? || method_id.empty?


          #TODO This doesn't work for 'common' functions that might apply to multiple regions and subregions! I need to map out that scenario using
          #     existing definitions...
          #
          # When attempting to find:
          #
          # 1) If there is no provided region then just look up by method_id
          # 2) If region is provided then look up by method_id:
          #   2a) If method_id is found then check the value:
          #     2aa) If the value is a proc then simply return the proc
          #     2ab) If the value is a hash then look up the region:
          #       2aaa) If the region is found the return the proc
          #       2aab) If the region is not found then return nil
          #   2b) If method_id is not found then return nil
          @custom_methods[method_id]
        end
      end
    end
  end
end
