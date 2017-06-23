import { ViewChild, Component, ElementRef, Input } from '@angular/core';
import { BenefitPackage } from './benefit_package';
import { BenefitPackageComponent } from './benefit_package.component';
import { NewPlanYearOptions } from './new_plan_year_options';
import { ServiceAreaOfferingsService } from './service_area_offerings_service';
import { DatePipe } from '@angular/common';
import * as Moment from "moment";
import { UUID } from 'angular2-uuid';
import * as $ from 'jquery';

@Component({
	selector: "[data-angular2-new-plan-year-form]",
	templateUrl: "./new_plan_year.component.html",
	providers: [ServiceAreaOfferingsService]
})
export class NewPlanYearComponent {
	employer_profile_id : string = "";
	plan_year_start_on : string = "";
	open_enrollment_start_date : string = "";
	open_enrollment_end_date: string = "";
	@ViewChild("oeStartDateInput") oeStartDateInput : ElementRef;
	@ViewChild("oeEndDateInput") oeEndDateInput : ElementRef;
	available_start_dates : string[][] = [];
	site_short_name : string = "";
	show_benefit_groups : boolean = false;
	componentUUID : UUID;
	employer_id : string = "";

	ftes : number | null;
	ptes : number | null;
	msps : number | null;

	benefit_packages : BenefitPackage[] = [];

	constructor(private elementRef: ElementRef, private serviceAreaOptionsService : ServiceAreaOfferingsService) {
          this.componentUUID = UUID.UUID();
	}

	ngOnInit() {
		var new_options : NewPlanYearOptions = JSON.parse(this.elementRef.nativeElement.getAttribute("data-angular2-new-plan-year-options"));
		this.available_start_dates = new_options.available_start_dates;
		this.site_short_name = new_options.site_short_name;
		this.employer_id = new_options.employer_id;
		if (!this.show_benefit_groups) {
		$(this.oeStartDateInput.nativeElement).on("input", (evt) => {
			this.open_enrollment_start_date = (<HTMLInputElement>evt.target).value;
		});
		$(this.oeEndDateInput.nativeElement).on("input", (evt) => {
			this.open_enrollment_end_date = (<HTMLInputElement>evt.target).value;
		});
		}
	}

	setCalendars(base_element_name : string, val: string) {
		var hidden_element_id = base_element_name + "_input_" + this.componentUUID;
		var control_element_id = base_element_name + "_control_" + this.componentUUID;
		eval(`$("#${control_element_id}").datepicker({
		  altField: \"#${hidden_element_id}\",
                  altFormat: \"yy-mm-dd\",
		  defaultDate: \"${val}\",
			onSelect: function() {
				$(\"#${hidden_element_id}\").trigger(\"input\");
			}
		});`);
	}

	ngAfterContentChecked() {
		this.setCalendars("open_enrollment_start_date", this.open_enrollment_start_date);
		this.setCalendars("open_enrollment_end_date", this.open_enrollment_end_date);
	}

        changeOEStartDate(event: any) {
		alert(event);
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
		this.benefit_packages = [new BenefitPackage(this.serviceAreaOptionsService, this.employer_id)];
	}
}
