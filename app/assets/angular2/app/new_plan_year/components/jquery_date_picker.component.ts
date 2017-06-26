import { Component, Input, Output, EventEmitter, ViewChild, ElementRef } from "@angular/core";
import { UUID } from 'angular2-uuid';
import * as $ from 'jquery';

@Component({
	selector: "jquery-date-picker",
	templateUrl: "../templates/jquery_date_picker.component.html"
})
export class JqueryDatePickerComponent {
	@Input() value : string = "";
	@Input() classNames : string = "";
	@Input() name : string = "";
	@Input() required : boolean = false;
	@ViewChild("hiddenDateControlInput") hiddenDateControlInput: ElementRef;
	@Input() placeHolder : string = "";
        @Output() valueChange = new EventEmitter();
	componentUUID : UUID;

	constructor() {
		this.componentUUID = UUID.UUID();
	}

	ngOnInit() {
		$(this.hiddenDateControlInput.nativeElement).on("input", (evt) => {
			this.value = (<HTMLInputElement>evt.target).value;
                        this.valueChange.emit(this.value);
		});
	}

        ngAfterContentChecked() {
          this.setCalendar(this.value);
        }

        hiddenControlId() {
           return(`jquery_date_picker_component_hidden_${this.componentUUID}`);
        }

        visibleControlId() {
           return(`jquery_date_picker_component_visible_${this.componentUUID}`);
        }

	setCalendar(val: string) {
		var hidden_element_id = this.hiddenControlId();
		var control_element_id = this.visibleControlId();
		eval(`$("#${control_element_id}").datepicker({
		  altField: \"#${hidden_element_id}\",
		  altFormat: \"yy-mm-dd\",
		  defaultDate: \"${val}\",
			onSelect: function() {
				$(\"#${hidden_element_id}\").trigger(\"input\");
			}
		});`);
	}
}
