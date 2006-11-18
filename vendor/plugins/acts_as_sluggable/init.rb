require 'acts_as_sluggable'
ActiveRecord::Base.send(:include, TeamSquad::Acts::Sluggable)