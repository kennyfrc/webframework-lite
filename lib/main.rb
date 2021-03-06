# frozen_string_literal: true

require_relative 'framework'
require_relative 'database'
require_relative 'queries'

DB = Database.connect('postgres://localhost/frameworklite_dev', QUERIES)

APP = App.new do
  get '/' do
    'This is the root'
  end

  get '/users/:username' do |params|
    "This is #{params.fetch('username')}!"
  end

  get '/submissions' do |_params|
    DB.all_submissions
  end

  get '/submissions/:name' do |params|
    name = params.fetch('name')
    user = DB.find_submission_by_name(name).fetch(0)
    "The user is #{user.fetch('name')}"
    # find the submission with that name
  end
end
