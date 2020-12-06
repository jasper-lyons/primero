module KPI
  # CaseLoad Search
  #
  # For cases created in a given range of months, looks at how many cases
  # each 'owner' (a User) has. This is aggregated into 4 bins for analysis.
  #
  # This is really time series data, the from / to here would mean how case
  # load has changed over time, not the load over cases created between
  # two dates.
  class CaseLoad < Search
    def search
      @search ||= Child.search do
        with :owned_by_groups, owned_by_groups

        facet :owned_by
      end
    end

    def data
      @data ||= [
        create_case_load(owners, '10cases', 0..10),
        create_case_load(owners, '20cases', 11..20),
        create_case_load(owners, '21-30cases', 21..30),
        create_case_load(owners, '30cases', 31..Float::INFINITY)
      ]
    end

    def to_json
      { data: data }
    end

    private

    def owners
      @owners ||= search.facet(:owned_by).rows
    end

    def create_case_load(owners, key, range)
      {
        case_load: key,
        percent: nan_safe_divide(
          owners.select { |owner| range.include?(owner.count) }.count,
          owners.count
        )
      }
    end

    def nan_safe_divide(numerator, denominator)
      return 0 if numerator.zero?

      numerator / denominator.to_f
    end
  end
end
