class Serializer::Item
  attr_accessor :record, :includes, :compound_opts, :current_controller, :format

  def initialize(item, includes: [], compound_opts: {}, **params)
    @record = item
    @includes = includes
    @compound_opts = compound_opts
    @current_controller = params[:current_controller]
    @format = params[:format]
  end

  def serializer_klass
    "#{record.class.name}Serializer".constantize
  end

  def as_json
    serializer_klass.new(record, include: relation_includes, format: format, current_controller: current_controller, **compound_opts).serializable_hash
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
