class Serializer::Pagination < Upframework::BaseService
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20

  attr_accessor :records, :page, :per_page

  def initialize(records: [], page:, per_page:, **params)
    @records = records
    @page = page
    @per_page = per_page
  end

  def execute
    paginate_scope
  end

  def result
    records
  end

  def paginate_scope
    @records = records.
      page(page || DEFAULT_PAGE).
      per(per_page || DEFAULT_PER_PAGE)
  end
end
