import { ViewChild, Component, ElementRef, Input } from '@angular/core';

import { BenefitPackage } from '../models/benefit_package';
import { OfferedCarrier } from '../models/offered_carrier';

@Component({
	selector: "benefit-package-component",
	templateUrl: "../templates/benefit_package.component.html"
})
export class BenefitPackageComponent {
	@Input() bg : BenefitPackage;

	titleFieldName() {
		return(`${this.bg.fieldNamePrefix()}[title]`);
	}
	descriptionFieldName() {
		return(`${this.bg.fieldNamePrefix()}[description]`);
	}
	effectiveOnFieldName() {
		return(`${this.bg.fieldNamePrefix()}[effective_on_offset]`);
	}

	planOptionKindRadioName() {
		return(`${this.bg.fieldNamePrefix()}[plan_option_kind]`);
	}

        selectedHealthPillClassFor(val : string) {
                if (this.bg.plan_option_kind == val) {
			return "active";
		}
		return "";
	}

	healthCarrierSelectionRadioIdFor(oc : OfferedCarrier) {
	  return(`${this.bg.fieldIdPrefix()}_carrier_for_elected_plan_${oc._id}`);
	}

	healthCarrierSelectionRadioName() {
		return(`${this.bg.fieldNamePrefix()}[carrier_for_elected_plan]`);
	}

	showHealthPlanSelection() {
		return this.bg.showHealthPlanSelection();
	}
}
