import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Cookie } from 'ng2-cookies/ng2-cookies';
import { OfferedCarrier } from '../models/offered_carrier';
import { OfferedPlan } from '../models/offered_plan';
import 'rxjs/add/operator/map'

@Injectable()
export class ServiceAreaOfferingsService {
	constructor(private http: Http) {
	}

	requestServicedCarriers(employer_id : string) {
		return (this.http.get('/employers/employer_profiles/' + employer_id + "/plan_years/offered_carriers.json", {withCredentials: true}).map(
			(res:Response) => <OfferedCarrier[]>res.json()
		));
	}

	requestOfferedPlansByMetal(employer_id : string, start_date: string, plan_option_kind: string, metal_level: string) {
		return(this.http.get('/employers/employer_profiles/' + employer_id + "/plan_years/offered_plans.json",
			{
				withCredentials: true,
				params: {
					plan_option_kind: plan_option_kind,
					start_on: start_date,
                                        metal_level: metal_level 
				}
			}
		        ).map(
			(res:Response) => <OfferedPlan[]>res.json()
		));
	}

	requestOfferedPlansByCarrier(employer_id : string, start_date: string, plan_option_kind: string, carrier_id: string) {
		return(this.http.get('/employers/employer_profiles/' + employer_id + "/plan_years/offered_plans.json",
			{
				withCredentials: true,
				params: {
					plan_option_kind: plan_option_kind,
					start_on: start_date,
                                        carrier_id: carrier_id
				}
			}
		        ).map(
			(res:Response) => <OfferedPlan[]>res.json()
		));
	}
}
