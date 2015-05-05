include ActionView::Helpers::NumberHelper

class Room < ActiveRecord::Base
  belongs_to      :floorplan
  has_many        :room_areas
  has_many        :room_mockup_images
  has_many        :room_mockups, through: :room_mockup_images
  
  def title_for_area_element
    s = self.label
    if self.nameable && !self.dollar_amount.nil?
      s = s + " (%s)" % number_with_delimiter(self.dollar_amount)
    end
    return s
  end
  
  def pending_or_nameable
    if self.pending_sale?
      return "pending"
    end
    return self.nameable? ? "yes" : "no"
  end
  
  # Return CSS class name used by anchor <a> element
  # 
  def link_element_css_class
    s = ''
    if self.pending_sale
      s = 'pending'
    else
      if !self.nameable
        s = 'non'
      end
      s = s + 'nameable'
    end
    return s + 'room'
  end
  
  def label_for_link_element
    s = self.label
    if self.nameable and (!self.dollar_amount.nil? and self.dollar_amount > 0)
      s = s + " ($%s)" % number_with_delimiter(self.dollar_amount)
    end
    return s
  end
  
  def self.aggregate_room(floorplan_name, nameable, room_label, dollar_amount)
    aggregate_room = nil
    
    return unless !room_label.nil?   
    label = room_label
    Rails.application.config.floorplan.room_label_problematic_char_dict.each do |bad, good|
      label.gsub! bad, good
    end
    
    filter_conditions = {:naming_opportunity => true, 'floorplans.name' => floorplan_name, :nameable => nameable}
    if room_label == Rails.application.config.floorplan.study_carrels_id_substring
      filter_conditions['carrel'] = true
      label = 'Study Carrels'
    else
      filter_conditions['label'] = room_label
      if !dollar_amount.nil? && dollar_amount
        filter_conditions[:dollar_amount] = dollar_amount
      end
    end 
    rooms = Room
      .select("rooms.id, floorplan_id, rooms.name, rooms.label, max(dollar_amount) as max_dollar_amount")
      .joins(:floorplan).find_by filter_conditions
      
    if rooms && !rooms.max_dollar_amount.nil?
      label_string = ''
      if !nameable
        label_string = 'Named '
      end
      
      Rails.application.config.floorplan.room_label_problematic_char_dict.each do |bad, good|
        room_label.gsub! bad, good
      end

      aggregate_room = Room.new
      aggregate_room.id = rooms.id
      aggregate_room.name = Room.aggregate_room_id(floorplan_name, nameable, room_label, dollar_amount)
      aggregate_room.label = "%s%s" % [label_string, label]
      aggregate_room.floorplan = rooms.floorplan
      aggregate_room.nameable = nameable
      aggregate_room.dollar_amount = rooms.max_dollar_amount
      aggregate_room.room_areas = rooms.room_areas
    end
    return aggregate_room
  end
  
  def self.aggregate_room_id(floorplan_name, nameable, room_label, dollar_amount = nil)
    nameable_portion = ''
    if !nameable
      nameable_portion = '%s%s' %
        [
          Rails.application.config.floorplan.room_aggregate_room_name_delimeter,
          Rails.application.config.floorplan.study_carrels_id_named_substring
        ]
    end
    
    room_name = room_label.gsub(' ', Rails.application.config.floorplan.aggregate_room_label_space_replacement).downcase
    
    dollar_amount_with_delimeter = ''
    if !dollar_amount.nil? && dollar_amount
      if !room_name.include? Rails.application.config.floorplan.study_carrels_id_substring
        dollar_amount_with_delimiter = '%s%s' %
          [
            Rails.application.config.floorplan.aggregate_room_name_dollar_amount_delimeter,
            dollar_amount
          ]
      end
    end
    
    return '%s%s%s%s%s' % 
      [
        floorplan_name,
        nameable_portion,
        Rails.application.config.floorplan.room_aggregate_room_name_delimeter,
        room_name,
        dollar_amount_with_delimiter
      ]
  end
end
