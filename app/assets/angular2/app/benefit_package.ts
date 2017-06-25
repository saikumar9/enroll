import { RelationshipBenefit } from "./relationship_benefit";
import { CompositeTierContribution } from "./composite_tier_contribution";
import { ServiceAreaOfferingsService } from './service_area_offerings_service';
import { OfferedCarrier } from './offered_carrier';

export class BenefitPackage {
	title: string = "";
	description : string = "";
	effective_on_offset : number = 0; 
	plan_option_kind : string = "";
	metal_level_for_elected_plan : string;

        relationship_benefits : RelationshipBenefit[] = [];
        dental_relationship_benefits : RelationshipBenefit[] = [];
	composite_tier_contributions : CompositeTierContribution[] = [];
	offered_carriers : OfferedCarrier[] = [];

	constructor(private saService : ServiceAreaOfferingsService, private employer_profile_id : string) {
	}

	selectCarriers() {
		if (this.offered_carriers.length < 1) {
			this.saService.requestServicedCarriers(this.employer_profile_id).subscribe( 
				ocs => this.offered_carriers = ocs
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
}
