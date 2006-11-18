module TeamSquad
  module Acts #:nodoc:
    module Sluggable #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_sluggable(source, options = {})
          
          cattr_accessor :sluggable_source_field, :sluggable_target_field 
          
          self.sluggable_source_field = source
          self.sluggable_target_field = options[:target] || 'slug'
          
          before_validation :create_slug
          after_validation  :move_slug_errors_to_sluggable_field
          
          include TeamSquad::Acts::Sluggable::InstanceMethods
        end
      end
      
      module InstanceMethods
        def to_param
          self.send(self.class.sluggable_target_field)
        end
        
      private
        
        def create_slug
          return if self.send(self.class.sluggable_source_field).nil?
          slug_source = self.send(self.class.sluggable_source_field).dup
          slug_source.downcase!
          slug_source.gsub!(/['"]/, '')
          slug_source.gsub!(/\W|£/, ' ')
          slug_source.strip!
          slug_source.gsub!(/\ +/, '-')
          self.send("#{self.class.sluggable_target_field}=", slug_source)
        end
        
        def move_slug_errors_to_sluggable_field
          self.errors.add( 
            self.class.sluggable_source_field,
            errors.on(self.class.sluggable_target_field)
          ) unless errors.on(self.class.sluggable_target_field).nil?
        end
      end
      
    end
  end
end