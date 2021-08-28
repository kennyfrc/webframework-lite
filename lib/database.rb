# frozen_string_literal: true

require 'pg'

# Wrapper for the Postgres Database
class Database
  # separate initialization and destructive actions
  # will help with testing down the line
  def initialize(pg_conn, queries)
    @pg_conn = pg_conn
    @queries = queries
  end

  def self.connect(db_url, queries)
    pg_conn = PG::Connection.new(db_url)
    new(pg_conn, queries)
  end

  def method_missing(name, params = {})
    # the way this works is by using the % operator
    # to do string interpolation
    # 'hello %s' % 'kenn'
    sql = @queries.fetch(name)
    Executor.new(@pg_conn, sql, params).execute
    # .exec_params is part of the pg library
    # and it allows you to execute sql with
    # holes in it
  end

  class Record
    def initialize(row)
      @row = row
    end

    def method_missing(col_name)
      @row.fetch(col_name.to_s)
    end
  end

  class Executor
    def initialize(pg_conn, sql, params)
      @pg_conn = pg_conn
      @sql = sql
      @params = params
    end

    def execute
      re = /{[a-zA-Z]\w*}/

      var_names = @params.keys
      args = @params.values

      sql = @sql.gsub(re) do |var_name_with_curlies|
        var_name = var_name_with_curlies.sub(/\A{/, '').sub(/}\z/, '').to_sym
        index = var_names.index(var_name) + 1
        "$#{index}"
      end

      @pg_conn.exec_params(sql, args).to_a.map do |row|
        Record.new(row)
      end
    end
  end
end
