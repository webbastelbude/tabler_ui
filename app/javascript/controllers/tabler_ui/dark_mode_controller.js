// app/javascript/controllers/tabler_ui/dark_mode_controller.js
import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["light", "dark", "system"]

    connect() {
        this.theme = localStorage.getItem("theme") || "system"
        localStorage.setItem("theme", this.theme)

        // Listen for system preference changes
        this.mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
        this.handleSystemChange = this.handleSystemChange.bind(this)
        this.mediaQuery.addEventListener('change', this.handleSystemChange)

        this.updateTheme()
        this.updateIcon()
    }

    disconnect() {
        if (this.mediaQuery) {
            this.mediaQuery.removeEventListener('change', this.handleSystemChange)
        }
    }

    toggle() {
        const nextTheme = {
            light: "dark",
            dark: "system",
            system: "light"
        }

        this.theme = nextTheme[this.theme]
        localStorage.setItem("theme", this.theme)

        this.updateTheme()
        this.updateIcon()
    }

    handleSystemChange(event) {
        if (this.theme === "system") {
            this.updateTheme()
        }
    }

    updateIcon() {
        if (this.hasLightTarget) {
            this.lightTarget.classList.toggle("d-none", this.theme !== "light")
        }
        if (this.hasDarkTarget) {
            this.darkTarget.classList.toggle("d-none", this.theme !== "dark")
        }
        if (this.hasSystemTarget) {
            this.systemTarget.classList.toggle("d-none", this.theme !== "system")
        }
    }

    updateTheme() {
        let isDark = false

        if (this.theme === "dark") {
            isDark = true
        } else if (this.theme === "system") {
            isDark = this.mediaQuery.matches
        }

        document.documentElement.setAttribute("data-bs-theme", isDark ? "dark" : "light")
    }
}
