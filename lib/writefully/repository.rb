require 'github_api'
require 'celluloid'

module Writefully
  class Repository
    include Celluloid

    attr_reader :owner, :access_token

    def initialize(access_token, owner)
      @owner = owner
      @access_token = access_token
    end

    def api
      @_api ||= ::Github.new oauth_token: access_token
    end

    def create blk
      result = # call github api 
      blk.call(result)
    end

    def add_hook blk
      result = #
    end
  end
end