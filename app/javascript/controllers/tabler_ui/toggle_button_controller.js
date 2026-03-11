import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "button"]
  static values = {
    color: { type: String, default: "primary" }
  }

  connect() {
    this.updateAppearance()
  }

  toggle() {
    this.checkboxTarget.checked = !this.checkboxTarget.checked
    this.checkboxTarget.dispatchEvent(new Event("change", { bubbles: true }))
    this.updateAppearance()
  }

  updateAppearance() {
    const checked = this.checkboxTarget.checked
    const btn = this.buttonTarget
    const color = this.colorValue

    btn.classList.remove(`btn-${color}`, `btn-ghost-${color}`)
    btn.classList.add(checked ? `btn-${color}` : `btn-ghost-${color}`)
  }
}
