import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { NewPlanYearComponent } from './new_plan_year.component';
import { BenefitPackageComponent } from './benefit_package.component';

@NgModule({
declarations: [
	NewPlanYearComponent,
	BenefitPackageComponent
],
imports: [
BrowserModule,
FormsModule,
HttpModule
],
providers: [],
bootstrap: [NewPlanYearComponent]
})
export class NewPlanYearModule { }
