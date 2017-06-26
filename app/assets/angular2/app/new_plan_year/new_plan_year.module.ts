import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { NewPlanYearComponent } from './components/new_plan_year.component';
import { BenefitPackageComponent } from './components/benefit_package.component';
import { JqueryDatePickerComponent } from './components/jquery_date_picker.component';

@NgModule({
declarations: [
	NewPlanYearComponent,
	BenefitPackageComponent,
	JqueryDatePickerComponent
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
