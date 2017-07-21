import { ViewChild, Component, ElementRef, Input } from '@angular/core';
import { BenefitPackage } from '../models/benefit_package';
import { NewPlanYearOptions } from '../models/new_plan_year_options';
import { ServiceAreaOfferingsService } from '../services/service_area_offerings_service';
import * as Moment from "moment";
import { UUID } from 'angular2-uuid';
import * as $ from 'jquery';

@Component({
	selector: "[data-angular2-new-plan-year-form]",
	templateUrl: "../templates/new_plan_year.component.html",
	providers: [ServiceAreaOfferingsService]
})
export class NewPlanYearComponent {
	employer_profile_id : string = "";
	plan_year_start_on : string = "";
	open_enrollment_start_date : string = "";
	open_enrollment_end_date: string = "";
	available_start_dates : string[][] = [];
	site_short_name : string = "";
	show_benefit_groups : boolean = false;
	componentUUID : UUID;
	employer_id : string = "";

	ftes : number | null;
	ptes : number | null;
	msps : number | null;

	benefit_package_index : number = 0;
	benefit_packages : BenefitPackage[] = [];

	constructor(private elementRef: ElementRef, private serviceAreaOptionsService : ServiceAreaOfferingsService) {
          this.componentUUID = UUID.UUID();
	}

	ngOnInit() {
		var new_options : NewPlanYearOptions = JSON.parse(this.elementRef.nativeElement.getAttribute("data-angular2-new-plan-year-options"));
		this.available_start_dates = new_options.available_start_dates;
		this.site_short_name = new_options.site_short_name;
		this.employer_id = new_options.employer_id;
	}


	planYearEndOnValue() {
		if (this.plan_year_start_on == "") {
			return "";
		}
		var date = Moment( this.plan_year_start_on, "YYYY-MM-DD").add(1, "y").subtract(1, "d");
		return date.format("YYYY-MM-DD"); 
	}

        planYearCompleted() { 
		return(this.displayDeadlines());
	}

        displayDeadlines() : boolean {
		var allSupplied = (this.plan_year_start_on != "") && (this.open_enrollment_start_date != "") && (this.open_enrollment_end_date != "");
		return allSupplied;
	}

        showBenefitGroups() {
		this.show_benefit_groups = true;
		this.benefit_packages = [new BenefitPackage(this.serviceAreaOptionsService, this.employer_id, 0, this.plan_year_start_on)];
		this.benefit_package_index = this.benefit_package_index + 1;
	}
}
