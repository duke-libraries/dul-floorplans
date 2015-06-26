module AreaShapes
  extend ActiveSupport::Concern
  
  included do
    @area_shapes = [['Poly', 'poly'], ['Rect', 'rect']]
    attr_reader :area_shapes
  end
  
end