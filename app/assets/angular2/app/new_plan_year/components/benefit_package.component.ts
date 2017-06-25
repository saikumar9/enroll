import { ViewChild, Component, ElementRef, Input } from '@angular/core';

import { BenefitPackage } from '../models/benefit_package';

@Component({
	selector: "benefit-package-component",
	templateUrl: "../templates/benefit_package.component.html"
})
export class BenefitPackageComponent {
	@Input() bg : BenefitPackage;
}
