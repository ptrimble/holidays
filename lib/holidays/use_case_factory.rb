require 'holidays/use_case/context/context_common'
require 'holidays/use_case/context/between'
require 'holidays/use_case/context/next_holiday'
require 'holidays/use_case/context/dates_driver_builder'
require 'holidays/use_case/context/year_holiday'

module Holidays
  class UseCaseFactory
    class << self
      def between
        UseCase::Context::Between.new(
          DefinitionFactory.holidays_by_month_repository,
          DateCalculatorFactory.day_of_month_calculator,
          DefinitionFactory.custom_methods_repository,
          DefinitionFactory.proc_result_cache_repository,
        )
      end
      def next_holiday
        UseCase::Context::NextHoliday.new(
          DefinitionFactory.holidays_by_month_repository,
          DateCalculatorFactory.day_of_month_calculator,
          DefinitionFactory.custom_methods_repository,
          DefinitionFactory.proc_result_cache_repository,
        )
      end

      def year_holiday
        UseCase::Context::YearHoliday.new(
          DefinitionFactory.holidays_by_month_repository,
          DateCalculatorFactory.day_of_month_calculator,
          DefinitionFactory.custom_methods_repository,
          DefinitionFactory.proc_result_cache_repository,
        )
      end

      def dates_driver_builder
        UseCase::Context::DatesDriverBuilder.new
      end
    end
  end
end
