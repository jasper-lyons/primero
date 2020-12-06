module KPI
  # CaseClosureRate Search
  #
  # Looks at how many cases were closed in a given range of months for
  # each location in which a case was closed within that range of months.
  class CaseClosureRate < PivotedRangeSearch
    search_model Child
    pivot_field :owned_by_location
    range_field :date_closure
    
    def search
      super do |search|
        search.with :date_closure, from..to
        search.with :status, Record::STATUS_CLOSED
      end
    end

    def to_json
      {
        dates: columns,
        data: data
      }
    end
  end
end
