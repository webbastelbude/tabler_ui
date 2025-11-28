// app/javascript/controllers/tabler_ui/datepicker_controller.js
import {Controller} from "@hotwired/stimulus"
import "vanillajs-datepicker";

export default class extends Controller {
    connect() {
        const minDate = this.element.dataset.min || null
        const maxDate = this.element.dataset.max || null
        const dateFormat = this.element.dataset.format || 'yyyy-mm-dd' // Default format

        if (this.element.tagName === "INPUT") {
            const datepicker = new Datepicker(this.element,
                {
                    buttonClass: 'btn',
                    autohide: true,
                    format: dateFormat, // Format from data attribute of input field
                    minDate: minDate ? new Date(minDate) : null, // minDate from input field
                    maxDate: maxDate ? new Date(maxDate) : null, // maxDate from input field
                    weekNumbers: 1,
                    weekStart: 1
                });

        } else {
            const datepicker = new DateRangePicker(this.element,
                {
                    buttonClass: 'btn',
                    format: dateFormat, // Format from data attribute of input field
                    minDate: minDate ? new Date(minDate) : null, // minDate from input field
                    maxDate: maxDate ? new Date(maxDate) : null, // maxDate from input field
                    weekNumbers: 1,
                    weekStart: 1,
                    autohide: true
                });
        }
    }
}
