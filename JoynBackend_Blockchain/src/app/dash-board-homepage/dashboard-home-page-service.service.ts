import { Injectable } from '@angular/core';
import { HttpClient} from '@angular/common/http';

import { checkUrl } from '../Deployment';

@Injectable({
  providedIn: 'root'
})
export class DashboardHomePageServiceService {

  constructor(private http:HttpClient) { }

  getAdminTotalToken(){
    return this.http.get(checkUrl()+'/api/getAdminTotalToken')
    .pipe((response)=>{
      return response;
    })

  }

  //Get user data of all the registered joyn users.
  getAllUsers(){
    return this.http.get(checkUrl()+'/api/getAllUsersDetails')
    .pipe((response)=>{
      return response;
    });
  }
}
