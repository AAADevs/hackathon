import { Component, OnInit } from '@angular/core';
import { LandinPageService } from './landin-page.service';
import { Router} from '@angular/router';


@Component({
  selector: 'app-landing-page',
  templateUrl: './landing-page.component.html',
  styleUrls: ['./landing-page.component.css']
})
export class LandingPageComponent implements OnInit {

  user: any = {};
  showError = false;
  passwordError = false;
  showLoginError = false;
  authorizedError = false;

  constructor(private auth:LandinPageService, private router: Router) { }

  ngOnInit(): void {}

  //Login for admin
  submit() {
    this.passwordError=false;
    this.showError=false;
    this.showLoginError=false;
    if(this.user.username && this.user.password)
      {
        if(this.user.password.length>=5){
        this.auth.login(this.user).subscribe((data: any) => {
          if(data.result){
            this.showError=false;
            sessionStorage.setItem('token', data.token)
            sessionStorage.setItem('username',data.username)
            this.router.navigate(['/dashboardHome']);
          }else{
            if(data.type == "credentials"){
              this.showError = true;
            }
            if(data.type == "authorization"){
              this.authorizedError = true;
            }
          }
        },
        err=>{
          console.log(err);
          this.showError=true;
        })
      }
      else
      {
        if(this.user.password.length<5)
        this.passwordError=true;
        else
        this.passwordError=false;
      }
    }
    else{
      this.showLoginError=true;
    }
  }

}
