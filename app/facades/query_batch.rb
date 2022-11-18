# frozen_string_literal: true
class QueryBatch
  attr_reader :cache_key

  def initialize(&block)
    @executor = QueryExecutor.new(block)
    @cache_key = ''
  end

  def load(ids)
    @cache_key += ids.inspect
    @executor.add(ids)
    QueryResultPromise.new(ids, @executor)
  end

  class QueryExecutor
    def initialize(query_proc)
      @ids = Set.new
      @query_proc = query_proc
    end

    def add(ids)
      @ids += ids
    end

    def results
      @results ||= @query_proc.call(@ids.to_a)
    end
  end

  class QueryResultPromise
    include Enumerable

    def initialize(ids, executor)
      @ids = ids
      @executor = executor
    end

    def each(*args)
      results = @executor.results
      @ids.each(*args) do |id|
        yield results[id] if results[id]
      end
    end
  end
end
