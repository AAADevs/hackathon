import { NgModule } from '@angular/core';
import { AuthGuard } from './Auth.guard';
import { Routes, RouterModule } from '@angular/router';
import { LandingPageComponent } from './landing-page/landing-page.component';
import { DashBoardHomepageComponent } from './dash-board-homepage/dash-board-homepage.component'

const routes: Routes = [
  {path:'home',component:LandingPageComponent},
  {path:'dashboardHome',component:DashBoardHomepageComponent,canActivate:[AuthGuard]},
  {path:'**',redirectTo:'home'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})


export class AppRoutingModule { }
