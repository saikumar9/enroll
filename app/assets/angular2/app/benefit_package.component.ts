import { ViewChild, Component, ElementRef, Input } from '@angular/core';

import { BenefitPackage } from './benefit_package';

@Component({
	selector: "benefit-package-component",
	templateUrl: "./benefit_package.component.html"
})
export class BenefitPackageComponent {
	@Input() bg : BenefitPackage;
}
