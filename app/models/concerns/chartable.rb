# frozen_string_literal: true
module Chartable
  def chart_position(attribute, start_query = nil)
    attribute = self.class.connection.quote_column_name(attribute.to_s)
    partition = partition_by(start_query || self.class.all, attribute)
    self.class.from(partition, :s).select('s.id, s.position')
        .find_by('s.id = ?', id).try(:position)
  end

  private

  def partition_by(chain, attribute)
    # 'SELECT g.id, ROW_NUMBER() OVER('\
    # "  ORDER BY g.#{attribute} DESC,"\
    # '  g.created_at DESC) AS position'\
    # 'FROM games g'
    chain
      .select('id, ROW_NUMBER() OVER ('\
              "ORDER BY #{attribute} DESC, created_at DESC"\
              ') as position')
  end
end
