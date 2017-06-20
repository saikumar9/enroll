import { RelationshipBenefit } from "./relationship_benefit";
import { CompositeTierContribution } from "./composite_tier_contribution";

export class BenefitPackage {
	name : string = "";
	description : string = "";
	start_on_selection : string = "";
	plan_option_kind : string = "";

        relationship_benefits : RelationshipBenefit[] = [];
        dental_relationship_benefits : RelationshipBenefit[] = [];
	composite_tier_contributions : CompositeTierContribution[] = [];
}
