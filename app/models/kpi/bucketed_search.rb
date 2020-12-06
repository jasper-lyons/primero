module KPI
  # BucketedSearch
  #
  # Extracts the logic for a common form of search in which data is
  # aggregated into buckets over a range of data.
  class BucketedSearch < KPI::Search
    class <<self
      def restricted_field(field = nil)
        @restricted_field ||= field
      end

      def compared_field(field = nil)
        @compared_field ||= field
      end
    end

    def restricted_field
      SolrUtils.sunspot_setup(search_model).field(self.class.restricted_field)
    end

    def compared_field
      SolrUtils.sunspot_setup(search_model).field(self.class.compared_field)
    end

    def days(number)
      number.days.in_milliseconds
    end

    # For the purposes of this search 1 month is 30.4167 days or
    # 30.4167 * 24 * 60 * 60 * 1000 milliseconds
    def months(number)
      (number * days(30.4167)).round
    end

    def buckets
      raise NotImplementedError
    end

    # rubocop:disable Metrics/AbcSize
    def search(&block)
      @search ||= search_model.search do
        with :created_at, from..to
        with :owned_by_groups, owned_by_groups

        adjust_solr_params do |params|
          params[:facet] = true
          params[:'facet.interval'] = restricted_field.indexed_name
          params[:'facet.interval.set'] = buckets.map do |args|
            "{!key=#{args[:key]}}[#{args[:l] || '*'},#{args[:u] || '*'}]"
          end
        end

        # Allow subclasses to extend the search
        instance_exec(&block) if block
      end
    end
    # rubocop:enable Metrics/AbcSize

    def data
      raise NotImplementedError
    end
  end
end