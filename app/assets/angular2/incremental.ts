import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { AddressModule } from './app/address.module';
import { NewPlanYearModule } from './app/new_plan_year.module';

export function initAngularAddressFields() {
  platformBrowserDynamic().bootstrapModule(AddressModule);
  }

(<any>window).initAngularAddressFields = initAngularAddressFields;

export function initPlanYearNewForm() {
  platformBrowserDynamic().bootstrapModule(NewPlanYearModule);
}

(<any>window).initPlanYearNewForm = initPlanYearNewForm;
