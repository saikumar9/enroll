import { Component, Input, Output, EventEmitter, ViewChild, ElementRef } from "@angular/core";
import { UUID } from 'angular2-uuid';
import * as $ from 'jquery';
import * as Moment from "moment";

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
	@Input() placeholder : string = "";
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

	getCurrentViewDate() {
		if (this.value == "") {
		  return(this.value);
		}
                return(this.formatViewDate(this.value));
	}

	getFormattedToday() {
		return(Moment().format("MM/DD/YYYY"));
	}

	formatViewDate(val : string) {
		var date = Moment(val, "YYYY-MM-DD");
		return(date.format("MM/DD/YYYY"));
	}

	setCalendar(val: string) {
		var default_value = (val == "") ? this.getFormattedToday() : this.formatViewDate(val);
		var hidden_element_id = this.hiddenControlId();
		var control_element_id = this.visibleControlId();
		eval(`$("#${control_element_id}").datepicker({
		  altField: "#${hidden_element_id}",
		  altFormat: "yy-mm-dd",
		  dateFormat: "mm/dd/yy",
		  defaultDate: "${default_value}",
			onSelect: function() {
				$("#${hidden_element_id}").trigger("input");
			}
		});`);
	}
}
