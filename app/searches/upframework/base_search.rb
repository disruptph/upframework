class Upframework::BaseSearch < Upframework::BaseService
  DEFAULT_PAGE     = 1
  DEFAULT_PER_PAGE = 12

  def result
    @model_scope
  end

  def query(field)
    @model_scope = yield if field.present?
  end

  def paginate_scope
    return if @model_scope.nil?

    @model_scope = @model_scope.
      page(@page || DEFAULT_PAGE).
      per(@per_page || DEFAULT_PER_PAGE).
      order(created_at: :desc)
  end

  module ExecuteWrapper
    def execute
      super
      paginate_scope
    end
  end

  include ExecuteWrapper
end
