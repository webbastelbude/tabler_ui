// Stimulus controller for custom Tabler UI dropdowns
// Note: Tabler uses Bootstrap 5's JavaScript by default (data-bs-toggle="dropdown")
// This controller is only needed if you want custom dropdown behavior without Bootstrap JS

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.outsideClickListener = this.handleOutsideClick.bind(this)
  }

  toggle(event) {
    event.preventDefault()
    if (this.menuTarget.classList.contains("show")) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.menuTarget.classList.add("show")
    document.addEventListener("click", this.outsideClickListener)
  }

  close() {
    this.menuTarget.classList.remove("show")
    document.removeEventListener("click", this.outsideClickListener)
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickListener)
  }
}
