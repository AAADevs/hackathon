import { TestBed } from '@angular/core/testing';

import { LandinPageService } from './landin-page.service';

describe('LandinPageService', () => {
  let service: LandinPageService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LandinPageService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
