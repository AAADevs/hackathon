import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpErrorResponse,HttpParams } from '@angular/common/http';
import { checkUrl } from '../Deployment';

@Injectable({
  providedIn: 'root'
})
export class LandinPageService {

  constructor(private http:HttpClient) { }

  //Admin login
  login($data:any)
  {
    return this.http.post(checkUrl()+"/api/adminLogin", $data)
  }
}
