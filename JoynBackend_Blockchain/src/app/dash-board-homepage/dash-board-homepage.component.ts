import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { DashboardHomePageServiceService } from './dashboard-home-page-service.service';


@Component({
  selector: 'app-dash-board-homepage',
  templateUrl: './dash-board-homepage.component.html',
  styleUrls: ['./dash-board-homepage.component.css']
})
export class DashBoardHomepageComponent implements OnInit {

  userData:any = {};
  adminAccountTokenBalance:any = {};

  constructor(private dashboardService:DashboardHomePageServiceService,private router:Router) { }

  ngOnInit(): void {
    this.getAdminAccountTotalToken();
    this.getAllUserData(); 
  }


  getAdminAccountTotalToken(){
    this.dashboardService.getAdminTotalToken().subscribe(data=>{
      this.adminAccountTokenBalance = data;
    })
  }

  //Get a list/object of all users data
  getAllUserData(){
    this.dashboardService.getAllUsers().subscribe(data=>{
      this.userData = data;
    })
  }

}
