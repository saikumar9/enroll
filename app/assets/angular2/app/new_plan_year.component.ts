import { Component, ElementRef } from '@angular/core';
import { BenefitPackage } from './benefit_package';
import { NewPlanYearOptions } from './new_plan_year_options';
import { DatePipe } from '@angular/common';
import * as Moment from "moment";

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

	ftes : number = 0;
	ptes : number = 0;
	msps : number = 0;

	benefit_packages : BenefitPackage[] = [];

	constructor(private elementRef: ElementRef) {
	}

	ngOnInit() {
		var new_options : NewPlanYearOptions = JSON.parse(this.elementRef.nativeElement.getAttribute("data-angular2-new-plan-year-options"));
		this.available_start_dates = new_options.available_start_dates;
		this.site_short_name = new_options.site_short_name;
	}

	planYearEndOnValue() {
		if (this.plan_year_start_on == "") {
			return "";
		}
		var date = Moment( this.plan_year_start_on, "YYYY-MM-DD").add(1, "y").subtract(1, "d");
		return date.format("YYYY-MM-DD"); 
	}
}
