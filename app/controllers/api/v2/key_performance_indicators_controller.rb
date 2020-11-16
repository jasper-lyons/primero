# frozen_string_literal: true

class Api::V2::KeyPerformanceIndicatorsController < ApplicationApiController
  def show
    authorize! kpi_permission, KPI
    search_klass = KPI::Search.find(kpi_id)
    search = search_klass.new(from, to)
    @data = search.to_json
  end

  private

  def kpi_permission
    "kpi_#{kpi_id}".to_sym
  end

  def kpi_id
    params[:id]
  end

  def from
    Sunspot::Type.for_class(Date).to_indexed(params[:from])
  end

  def to
    Sunspot::Type.for_class(Date).to_indexed(params[:to])
  end
end
