class FormSectionController < ApplicationController

  before_filter :current_modules, :only => [:index, :new, :edit]
  before_filter :parent_form, :only => [:new, :edit]
  before_filter :get_form_sections, :only => [:index]
  #before_filter :get_lookups, :only => [:index]


  def index
    authorize! :index, FormSection
    @page_name = t("form_section.manage")
  end

  def new
    authorize! :create, FormSection
    @page_name = t("form_section.create")
    @form_section = FormSection.new(params[:form_section])
    unless @form_section.order.present?
      @form_section.order = 999
    end
    unless @form_section.order_form_group.present?
      @form_section.order_form_group = 999
    end
  end

  def create
    authorize! :create, FormSection
    form_section = FormSection.new_with_order params[:form_section]
    form_section.base_language = I18n.default_locale
    if (form_section.valid?)
      form_section.create

      #TODO WIP.... kinda hack... need to refactor
      module_id = params[:module_id]
      if module_id.present?
        primero_module = PrimeroModule.get(module_id)
        if primero_module.present?
          unless primero_module.associated_form_ids.include? form_section.unique_id
            primero_module.associated_form_ids << form_section.unique_id

            primero_module.save
          end
        end
      end

      flash[:notice] = t("form_section.messages.updated")
      redirect_to edit_form_section_path(form_section.unique_id)
    else
      @form_section = form_section
      render :new
    end
  end

  def edit
    authorize! :update, FormSection
    @page_name = t("form_section.edit")
    @form_section = FormSection.get_by_unique_id(params[:id])
  end

  def update
    authorize! :update, FormSection
    @form_section = FormSection.get_by_unique_id(params[:id])
    @form_section.properties = params[:form_section]
    if (@form_section.valid?)
      @form_section.save!
      redirect_to edit_form_section_path(@form_section.unique_id)
    else
      render :action => :edit
    end
  end

  def toggle
    authorize! :update, FormSection
    form = FormSection.get_by_unique_id(params[:id])
    form.visible = !form.visible?
    form.save!
    render :text => "OK"
  end


  def save_order
    authorize! :update, FormSection
    params[:ids].each_with_index do |unique_id, index|
      form_section = FormSection.get_by_unique_id(unique_id)
      form_section.order = index + 1
      form_section.save!
    end
    redirect_to form_sections_path
  end

  def published
    json_content = FormSection.find_all_visible_by_parent_form(parent_form).map(&:formatted_hash).to_json
    respond_to do |format|
      format.html {render :inline => json_content }
      format.json { render :json => json_content }
    end
  end


  private

  def current_modules
    @current_modules ||= current_user.modules
    @module_id = params[:module_id] || @current_modules.first.id
    @module = @current_modules.select{|m| m.id == @module_id}.first
  end

  def parent_form
    @parent_form = params[:parent_form] || 'case'
  end

  def get_form_sections
    @record_types = @module.associated_record_types

    #only use the passed in parent_form if it is in the allowed form types for this module
    #otherwise, default to the first allowed form type
    if (params[:parent_form].present? && (@record_types.include? params[:parent_form]))
      @parent_form = params[:parent_form]
    else
      @parent_form = @record_types.first
    end

    permitted_forms = FormSection.get_permitted_form_sections(@module, @parent_form, current_user)
    FormSection.link_subforms(permitted_forms)
    #filter out the subforms
    no_subforms = FormSection.filter_subforms(permitted_forms)
    @form_sections = FormSection.group_forms(no_subforms)
  end

end
