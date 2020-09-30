class Serializer::Sort < Upframework::BaseService
  attr_accessor :records

  def initialize(records: [], sort: nil, **params)
    @records = records
    @sort = sort
  end

  def execute
    sort_scope
  end

  def result
    records
  end

  def sort_scope
    #TODO sort scope here
  end
end
