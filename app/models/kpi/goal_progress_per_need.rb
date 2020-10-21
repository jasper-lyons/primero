module KPI
  # GoalProgressPerNeed Search
  #
  # For cases created within a given range of months, looks at how much
  # progress has been made towards meeting the needs (or goals) of a
  # survivor. How a need / goal is defined and how to calculate it's
  # complection is defined in:
  # app/models/concerns/gbv_key_performance_indicators.rb
  class GoalProgressPerNeed < Search
    def search
      @search ||= Child.search do
        with :status, Record::STATUS_OPEN
        with :created_at, from..to

        stats :safety_goals_progress,
          :health_goals_progress,
          :psychosocial_goals_progress,
          :justice_goals_progress,
          :other_goals_progress
      end
    end

    def data
      [
        create_goal_progress('safety', :safety_goals_progress),
        create_goal_progress('health', :health_goals_progress),
        create_goal_progress('psychosocial', :psychosocial_goals_progress),
        create_goal_progress('justice', :justice_goals_progress),
        create_goal_progress('other', :other_goals_progress)
      ]
    end

    def to_json
      { data: data }
    end

    private

    def create_goal_progress(label, stat_key)
      {
        need: I18n.t("key_performance_indicators.goal_progress_per_need.#{label}"),
        percentage: handle_solr_stats_value(search.stats(stat_key).mean)
      }
    end

    def handle_solr_stats_value(value)
      if value == 'NaN' || value.nil?
        0.0
      else
        value
      end
    end
  end
end