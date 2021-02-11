import {
    HttpEvent,
    HttpInterceptor,
    HttpHandler,
    HttpRequest,
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { Router } from '@angular/router'

// Creating an interceptor to pass the default header for every API call.
   
export class AddHeaderInterceptor implements HttpInterceptor {
    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {

      //Passing the JWT token to the backend

      let token:any = null;

      if(sessionStorage.token == undefined || sessionStorage.token == null ){
        token = 'NA'
      }
      else{
        token = sessionStorage.getItem('token');
      }

      // Clone the request to add the new header

      const clonedRequest = req.clone({ setHeaders: { 
            joyn_api_secret_key: '2dggf6df8jnvju9377jdjgjfdgdfn74ennjjruufnvnj525234gh',
            Authorization: token
          } 
      });
      
      // Pass the cloned request instead of the original request to the next handle

      return next.handle(clonedRequest);
      
    }
}