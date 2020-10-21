module KPI
  class ClientSatisfactionRate < Search
    def search
      Child.search do
        with :created_at, from..to

        any_of do
          with :satisfaction_status, 'satisfied'
          with :satisfaction_status, 'unsatisfied'
        end

        facet :satisfaction_status, only: 'satisfied'
      end
    end

    def to_json
      {
        data: {
          satisfaction_rate: nan_safe_divide(
            search.facet(:satisfaction_status).rows.first&.count || 0,
            search.total
          )
        }
      }
    end
  end
end