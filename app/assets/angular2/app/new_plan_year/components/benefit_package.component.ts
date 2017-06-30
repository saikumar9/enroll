import { ViewChild, Component, ElementRef, Input } from '@angular/core';

import { BenefitPackage } from '../models/benefit_package';

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

	planOptionKindRadioIdFor(selection: string) {
		return(`${this.bg.fieldIdPrefix()}_plan_option_kind_${selection}`);
	}
}
