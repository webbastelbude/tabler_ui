import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { debounce: Number }

  connect() {
    console.log("✅ FilterController connected", this.element)
    this._debouncedSubmit = this._debounce(
      () => this.element.requestSubmit(),
      this.debounceValue || 200
    )
  }

  submit() {
    console.log("🔔 submit triggered")
    this._debouncedSubmit()
  }

  _debounce(fn, wait) {
    let t
    return (...args) => {
      clearTimeout(t)
      t = setTimeout(() => fn.apply(this, args), wait)
    }
  }
}
