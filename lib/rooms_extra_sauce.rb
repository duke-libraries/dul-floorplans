# /lib/rooms_extra_sauce.rb

module RoomsExtraSauce
  class RoomsAggregate
    def new(*args)
      
    end
    
    def initialize(*categories)
      @room_categories = categories.first
      @room_labels = {}
    end
    
    def process_room(room)
      room_label = room.label
      Rails.application.config.floorplan.room_label_problematic_char_dict.each do |bad, good|
        room_label.gsub! bad, good
      end

      if !room.nameable?
        label_key = room.carrel? ? "Named Study Carrels" : room.label
      else
        if room.label.starts_with? 'Study Carrel'
          label_key = 'Study Carrel'
        else
          label_key = room.label_for_link_element()
        end
      end
      
      category = false
      if (room.nameable?)
        @room_categories.select {|k, v| v.has_key? :min }.each do |k, v|
          if v.has_key? :max
            if (v[:min]..v[:max]).include? room.dollar_amount.to_i
              category = k
              break
            end
          else
            if room.dollar_amount.to_i > v[:min]
              category = k
              break
            end
          end
        end
      else
        category = :named_spaces
      end
      
      data_roomgroup = Room.aggregate_room_id(room.floorplan.name, room.nameable, room_label, room.dollar_amount)
      
      if !@room_labels.has_key? label_key
        @room_labels[label_key] = {
          :room => room,
          :room_areas => [], 
          :data_roomgroup => data_roomgroup,
          :category => category
        }
      end

      room.room_areas.each do |room_area|
        @room_labels[label_key][:room_areas].push room_area
      end
      
    end
    
    def room_labels
      return @room_labels
    end
  end
end