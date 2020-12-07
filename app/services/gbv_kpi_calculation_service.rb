class GbvKpiCalculationService
  def initialize(child)
    @child = child
  end

  def case_lifetime_days
    return 0 unless @child.status == Record::STATUS_CLOSED
    closure_form = form_responses(:gbv_case_closure_form).first
    date_created = closure_form.field(:created_at) || @child.created_at
    date_closed = closure_form.field(:date_closure)
    (date_closed.to_date - date_created.to_date).to_i
  end

  def completed_survivor_assessment
    form_responses(:survivor_assessment_form).any?(&:complete?)
  end

  def requires_safety_plan?
    form_responses(:safety_plan)
      .field(:safety_plan_needed)
      .any? { |result| result == 'yes' }
  end
  alias safety_plan_required requires_safety_plan?

  def completed_safety_plan
    form_responses(:safety_plan).any?(&:complete?)
  end

  def completed_action_plan
    form_responses(:action_plan_form)
      .subform(:action_plan_section)
      .any?(&:complete?)
  end

  def completed_and_approved_action_plan
    response = form_responses(:action_plan_form).first
    response &&
      response.field(:action_plan_approved) &&
      response.subform(:action_plan_section).any?(&:complete?)
  end

  def services_provided
    form_responses(:action_plan_form)
      .subform(:gbv_follow_up_subform_section)
      .field(:service_type_provided)
      .uniq
  end

  def action_plan_referral_statuses
    form_responses(:action_plan_form)
      .subform(:action_plan_section)
      .field(:service_referral)
      .compact
  end

  def safety_goals_progress
    goal_progress(:gbv_assessment_progress_safety)
  end

  def health_goals_progress
    goal_progress(:gbv_assessment_progress_health)
  end

  def psychosocial_goals_progress
    goal_progress(:gbv_assessment_progress_psychosocial)
  end

  def justice_goals_progress
    goal_progress(:gbv_assessment_progress_justice)
  end

  def other_goals_progress
    goal_progress(:gbv_assessment_other_goals)
  end

  def satisfaction_status
    feedback_responses = KPI::ClientFeedbackResponseList.new(
      responses: access_migrated_forms(:client_feedback)
    )

    return nil unless feedback_responses.has_responses?

    if feedback_responses.satisfied >= feedback_responses.unsatisfied
      'satisfied'
    else
      'unsatisfied'
    end
  end

  def form_responses(form_section_unique_id)
    form_section = FormSection.find_by(unique_id: form_section_unique_id)
    form_section_results = access_migrated_forms(form_section_unique_id)

    return FormSectionResponseList.new(responses: [], form_section: nil) unless form_section
    FormSectionResponseList.new(responses: form_section_results, form_section: form_section)
  end

  # Previously forms whos parents were 'case' appeared as attributed in the
  # Chilkd.data field. Now, these forms treat the Child as the form, meaning
  # that they do not exist as properties on the Child anymore. To handle this
  # we can use this method until we're sure that all top level forms use the
  # Child.data attribute as the form.
  def access_migrated_forms(form_section_unique_id)
    @child.respond_to?(form_section_unique_id) && @child.send(form_section_unique_id) || [@child.data]
  end

  def percentage_goals_met(goals)
    return nil if goals.empty?

    applicable_goals = goals.count { |status| status != 'n_a' }
    return nil if applicable_goals.zero?

    met_goals = goals.count { |status| status == 'met' }
    return 0 if met_goals.zero?

    met_goals / applicable_goals.to_f
  end

  def goal_progress(goal_field)
    # Could maybe use a service object here? Wrap the case object
    # and manually manage creating FormSectionResponseLists.
    percentage_goals_met(
      form_responses(:action_plan_form)
        .subform(:gbv_follow_up_subform_section)
        .field(goal_field)
    )
  end
end
