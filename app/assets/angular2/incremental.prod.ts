import { enableProdMode } from '@angular/core';
import { platformBrowser }    from '@angular/platform-browser';

import { AddressModuleNgFactory } from './aot/app/address.module.ngfactory';
import { NewPlanYearModuleNgFactory } from './aot/app/new_plan_year.module.ngfactory';
import './polyfills';

export function initAngularAddressFields() {
  platformBrowser().bootstrapModuleFactory(AddressModuleNgFactory);
  }

(<any>window).initAngularAddressFields = initAngularAddressFields;

export function initPlanYearNewForm() {
  platformBrowser().bootstrapModuleFactory(NewPlanYearModuleNgFactory);
}

(<any>window).initPlanYearNewForm = initPlanYearNewForm;
