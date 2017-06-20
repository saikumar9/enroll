import { Component, ElementRef } from '@angular/core';
import { BenefitPackage } from './benefit_package';
import { NewPlanYearOptions } from './new_plan_year_options';
import { DatePipe } from '@angular/common';
import * as Moment from "moment";
import { UUID } from 'angular2-uuid';

@Component({
	selector: "[data-angular2-new-plan-year-form]",
	templateUrl: "./new_plan_year.component.html"
})
export class NewPlanYearComponent {
	employer_profile_id : string = "";
	plan_year_start_on : string = "";
	open_enrollment_start_date : string = "";
	open_enrollment_end_date: string = "";
	available_start_dates : string[][] = [];
	site_short_name : string = "";
	componentUUID : UUID;

	ftes : number = 0;
	ptes : number = 0;
	msps : number = 0;

	benefit_packages : BenefitPackage[] = [];

	constructor(private elementRef: ElementRef) {
          this.componentUUID = UUID.UUID();
	}

	ngOnInit() {
		var new_options : NewPlanYearOptions = JSON.parse(this.elementRef.nativeElement.getAttribute("data-angular2-new-plan-year-options"));
		this.available_start_dates = new_options.available_start_dates;
		this.site_short_name = new_options.site_short_name;
	}

	setCalendars(base_element_name : string, val: string) {
		var hidden_element_id = base_element_name + "_input_" + this.componentUUID;
		var control_element_id = base_element_name + "_control_" + this.componentUUID;
		eval("$(\"#" + control_element_id + "\").datepicker({\n\
                  altField: \"#" + hidden_element_id+ "\",\
                  altFormat: \"yyyy-mm-dd\",\
	          defaultDate: \"" + val + "\"\
		});");
	}

	ngAfterViewChecked() {
		this.setCalendars("open_enrollment_start_date", this.open_enrollment_start_date);
		this.setCalendars("open_enrollment_end_date", this.open_enrollment_end_date);
	}

	planYearEndOnValue() {
		if (this.plan_year_start_on == "") {
			return "";
		}
		var date = Moment( this.plan_year_start_on, "YYYY-MM-DD").add(1, "y").subtract(1, "d");
		return date.format("YYYY-MM-DD"); 
	}
}
