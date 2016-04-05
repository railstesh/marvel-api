require 'marvel/properties'

module Marvel
  class API
	require 'marvel/api/character'
	require 'marvel/api/comic'
	require 'marvel/api/creator'
	require 'marvel/api/event'
	require 'marvel/api/series'
	require 'marvel/api/story'


    extend Marvel::Properties::ConfigMethods
    extend Marvel::API::Character
    extend Marvel::API::Comic
    extend Marvel::API::Creator
    extend Marvel::API::Event
    extend Marvel::API::Series
    extend Marvel::API::Story
  end
end
