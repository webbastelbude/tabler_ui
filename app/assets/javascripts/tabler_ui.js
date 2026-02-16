/**
 * Tabler UI Gem JavaScript
 *
 * This is main entry point for Tabler UI JavaScript.
 * Import this file in your application to use Tabler UI interactive components.
 *
 * Stimulus controllers are auto-registered via window.Stimulus
 * (set by the host app's controllers/application.js).
 */

import "tabler_ui/tabler"
import "star-rating.js"

// Auto-register Stimulus controllers
import DarkModeController from "controllers/tabler_ui/dark_mode_controller"
import DatepickerController from "controllers/tabler_ui/datepicker_controller"
import DropdownController from "controllers/tabler_ui/dropdown_controller"
import FilterController from "controllers/tabler_ui/filter_controller"
import RatingController from "controllers/tabler_ui/rating_controller"

if (window.Stimulus) {
  const app = window.Stimulus
  app.register("tabler-ui--dark-mode", DarkModeController)
  app.register("tabler-ui--datepicker", DatepickerController)
  app.register("tabler-ui--dropdown", DropdownController)
  app.register("tabler-ui--filter", FilterController)
  app.register("tabler-ui--rating", RatingController)
}
