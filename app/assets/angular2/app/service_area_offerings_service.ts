import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Cookie } from 'ng2-cookies/ng2-cookies';
import { OfferedCarrier } from './offered_carrier';
import 'rxjs/add/operator/map'

@Injectable()
export class ServiceAreaOfferingsService {
	constructor(private http: Http) {
	}

	requestServicedCarriers(employer_id : String) {
		return (this.http.get('/employers/employer_profiles/' + employer_id + "/plan_years/offered_carriers.json", {withCredentials: true}).map(
			(res:Response) => <OfferedCarrier[]>res.json()
		));
	}
}
