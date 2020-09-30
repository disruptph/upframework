class Serializer::Collection
  attr_accessor :records, :includes, :compound_opts, :format, :current_controller

  def initialize(records, includes: [], compound_opts: {}, **params)
    @records = ::Serializer::Pagination.run(records: records, page: params[:page], per_page: params[:per_page], **params).result
    @records = ::Serializer::Sort.run(records: @records, sort: params[:sort], **params).result

    @includes = includes
    @compound_opts = compound_opts
    @format = params[:format]
    @current_controller = params[:current_controller]
  end

  def as_json
    serializer_klass.new(records, include: relation_includes, format: format, current_controller: current_controller, **compound_opts).serializable_hash
  end

  def serializer_klass
    resource_klass = records.klass if records.is_a? ActiveRecord::Relation
    resource_klass = records.first.class if records.is_a? Array

    "#{resource_klass.name}Serializer".constantize
  end

  def relation_includes
    relations = serializer_klass.default_includes

    @includes =
      if includes.is_a? String
        includes.split(",").map(&:underscore).map(&:to_sym)
      else
        Array(includes).map(&:to_sym)
      end

    relations.concat(includes.compact)
  end
end
