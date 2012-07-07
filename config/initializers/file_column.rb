require 'file_column/file_column'
require 'file_column/file_column_helper'

ActiveRecord::Base.send(:include, FileColumn)
ActionView::Base.send(:include, FileColumnHelper)
