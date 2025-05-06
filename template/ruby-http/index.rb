# Copyright (c) Alex Ellis 2017. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

require_relative 'function/handler'

require 'sinatra'

set :port, 5000
# set :bind, '0.0.0.0'

helpers do
  def respond_with(default_status)
    handler = Handler.new

    res, res_headers, status = handler.run request.body, request.env

    [status || default_status, res_headers, res]
  end
end

options '/*' do
  respond_with(204)
end

get '/*' do
  respond_with(200)
end

post '/*' do
  respond_with(200)
end

put '/*' do
  respond_with(200)
end

delete '/*' do
  respond_with(200)
end
