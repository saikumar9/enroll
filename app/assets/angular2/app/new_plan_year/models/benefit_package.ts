import { RelationshipBenefit } from "./relationship_benefit";
import { CompositeTierContribution } from "./composite_tier_contribution";
import { ServiceAreaOfferingsService } from '../services/service_area_offerings_service';
import { OfferedCarrier } from './offered_carrier';
import { OfferedPlan } from './offered_plan';
import { EventEmitter } from "@angular/core";

export class BenefitPackage {
	title: string = "";
	description : string = "";
	effective_on_offset : number = 0; 
	metal_level_for_elected_plan : string = "";
	carrier_for_elected_plan : string = "";

	private _plan_option_kind : string = "";
        get plan_option_kind() {
		return this._plan_option_kind;
	}
	set plan_option_kind(newVal: string) {
		if (newVal != this._plan_option_kind) {
			this.metal_level_for_elected_plan = "";
			this.carrier_for_elected_plan = "";
			this.offered_carriers = [];
			this.offered_plans = [];
		}
		this._plan_option_kind = newVal;
	}


        relationship_benefits : RelationshipBenefit[] = [];
        dental_relationship_benefits : RelationshipBenefit[] = [];
	composite_tier_contributions : CompositeTierContribution[] = [];
	offered_carriers : OfferedCarrier[] = [];
	offered_plans : OfferedPlan[] = [];

	constructor(private saService : ServiceAreaOfferingsService, private employer_profile_id : string, private index : number, private start_on : string) {
	}

	fieldNamePrefix() {
		return(`plan_year[benefit_groups_attributes][${this.index}]`); 
	}

	fieldIdPrefix() {
		return(`plan_year_benefit_groups_attributes__${this.index}_`); 
	}

	selectCarriers() {
		if (this.offered_carriers.length < 1) {
			this.saService.requestServicedCarriers(this.employer_profile_id).subscribe( 
				ocs => this.offered_carriers = ocs
			);
		}
		return true;
	}

	selectPlans() {
		if (this._plan_option_kind == "metal_level") {
			this.saService.requestOfferedPlansByMetal(this.employer_profile_id, this.start_on, this._plan_option_kind, this.metal_level_for_elected_plan).subscribe( 
				ocs => this.offered_plans = ocs
			);
		} else {
			this.saService.requestOfferedPlansByCarrier(this.employer_profile_id, this.start_on, this._plan_option_kind, this.carrier_for_elected_plan).subscribe( 
				ocs => this.offered_plans = ocs
			);
		}
		return true;
	}

	showCarrierSelection() {
		if (this.plan_option_kind == "") {
			return(false);
		}
		return(this.plan_option_kind != "metal_level");
	}

	showMetalLevelSelection() {
		if (this.plan_option_kind == "") {
			return(false);
		}
		return(this.plan_option_kind == "metal_level");
	}

	showHealthPlanSelection() {
		if (this.plan_option_kind == "") {
			return(false);
		}
		if (this.carrier_for_elected_plan != "") {
			return true;
		}
		return false;
	}
}
