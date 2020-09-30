class Upframework::BaseSearch < Upframework::BaseService
  DEFAULT_PAGE     = 1
  DEFAULT_PER_PAGE = 12

  def result
    @model_scope
  end

  def query(field)
    @model_scope = yield if field.present?
  end
end
