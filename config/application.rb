require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Floorplans
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    config.autoload_paths += %W(#{config.root}/lib)
    
    # Config settings for floorplan (and room, roomarea, etc)
    config.floorplan = ActiveSupport::OrderedOptions.new
    config.floorplan.study_carrels_id_substring = 'study_carrels'
    config.floorplan.room_label_problematic_char_dict = {'/' => '_', ',' => ''}
    config.floorplan.room_aggregate_room_name_delimeter = '-'
    config.floorplan.study_carrels_id_named_substring = 'named'
    config.floorplan.aggregate_room_label_space_replacement = "__"
    config.floorplan.aggregate_room_name_dollar_amount_delimeter = "___"
    config.floorplan.default_map_max_width = 500
    config.floorplan.thumbnail_max_height = 100
    #config.floorplan.nameable_room_color = "#00cc00"
    #config.floorplan.not_nameable_room_color = "#336699"
    #config.floorplan.pending_sale_room_color = "#800000"
    config.floorplan.nameable_room_color = '#0C6'
    config.floorplan.not_nameable_room_color = '#3CF'
    config.floorplan.pending_sale_room_color = '#C03'
    config.floorplan.map_opacity = 0.20
    config.floorplan.room_color_opacity = 0.21
  end
end
