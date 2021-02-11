import { TestBed } from '@angular/core/testing';

import { DashboardHomePageServiceService } from './dashboard-home-page-service.service';

describe('DashboardHomePageServiceService', () => {
  let service: DashboardHomePageServiceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(DashboardHomePageServiceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
