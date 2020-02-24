module Api::V2
  class KeyPerformanceIndicatorsController < ApplicationApiController
    # This is only temporary to avoid double render errors while developing.
    # I looks like this method wouldn't make sense for the audit log to
    # write given that 'write_audit_log' required a record type, id etc.
    # This response doesn't utilize any type of record yet and so cannot
    # provide this information.
    skip_after_action :write_audit_log

    def number_of_cases
      created_at = SolrUtils.indexed_field_name(Child, :created_at)
      owned_by_location = SolrUtils.indexed_field_name(Child, :owned_by_location)

      search = Child.search do
        facet :created_at,
          tag: :per_month,
          range: from...to,
          range_interval: '+1MONTH',
          minimum_count: -1

        pivot :owned_by_location,
          range: :per_month,
          minimum_count: -1

        paginate page: 1, per_page: 0
      end

      @columns = (from...to).
        map { |d| DateTime.new(d.year, d.month, 1, 0, 0, 0, to.zone).utc.iso8601 }.
        uniq

      @data = search.pivot(:owned_by_location).rows.
        map do |row|
          # use instance to get this?
          location = Location.
            find_by({ location_code: row.result['value'].upcase }).
            placename

          counts = row.range(:created_at).counts

          { reporting_site: location }.merge(counts)
        end

    end

    def number_of_incidents
    end

    def reporting_delay
    end

    def service_access_delay
    end

    def assessment_status
    end
    
    def completed_case_safety_plans
    end

    def completed_case_action_plans
    end

    def completed_supervisor_approved_case_action_plans
    end

    def services_provided
    end

    private

    # TODO: Add these to permitted params
    def from
      DateTime.parse(params[:from])
    end

    def to
      DateTime.parse(params[:to])
    end
  end
end
