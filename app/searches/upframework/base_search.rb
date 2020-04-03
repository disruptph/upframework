class Upframework::BaseSearch < Upframework::BaseService
  DEFAULT_PAGE     = 1
  DEFAULT_PER_PAGE = 12

  def result
    @model_scope
  end

  def query(field)
    @model_scope = yield if present_value?(field)
  end

  def paginate_scope
    @model_scope = @model_scope.
      page(@page || DEFAULT_PAGE).
      per(@per_page || DEFAULT_PER_PAGE).
      order(created_at: :desc)
  end

  def present_value?(field)
    instance_variable_get("@#{field}").present?
  end
end
