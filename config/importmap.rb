# Tabler UI Importmap Configuration
# This file is automatically loaded by Rails when the gem is used

pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'

# Pin Tabler UI JavaScript
pin 'tabler_ui', to: 'tabler_ui.js'
pin 'tabler_ui/tabler', to: 'tabler_ui/tabler.js'

# Pin external dependencies
pin 'vanillajs-datepicker', to: 'https://cdn.jsdelivr.net/npm/vanillajs-datepicker@1.3.4/dist/js/datepicker-full.min.js'

# Pin star-rating.js (bundled with gem)
pin 'star-rating.js', to: 'tabler_ui/star-rating.js'

# Pin Tabler UI Stimulus controllers
pin_all_from File.expand_path('../app/javascript/controllers/tabler_ui', __dir__), under: 'controllers/tabler_ui'
