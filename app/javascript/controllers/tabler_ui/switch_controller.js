// app/javascript/controllers/tabler_ui/switch_controller.js
import {Controller} from "@hotwired/stimulus"

// Schickt das umgebende Formular ab, sobald der Schalter umgelegt wird.
// Der Schalter wird währenddessen gesperrt, damit kein Doppelklick zwei Requests auslöst.
export default class extends Controller {
    submit(event) {
        event.target.disabled = true
        this.element.requestSubmit()
    }
}
