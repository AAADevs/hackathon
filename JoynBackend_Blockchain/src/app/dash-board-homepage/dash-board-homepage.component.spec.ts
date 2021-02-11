import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DashBoardHomepageComponent } from './dash-board-homepage.component';

describe('DashBoardHomepageComponent', () => {
  let component: DashBoardHomepageComponent;
  let fixture: ComponentFixture<DashBoardHomepageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DashBoardHomepageComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DashBoardHomepageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
