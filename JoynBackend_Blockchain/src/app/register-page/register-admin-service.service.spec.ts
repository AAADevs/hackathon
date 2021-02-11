import { TestBed } from '@angular/core/testing';

import { RegisterAdminServiceService } from './register-admin-service.service';

describe('RegisterAdminServiceService', () => {
  let service: RegisterAdminServiceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(RegisterAdminServiceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
