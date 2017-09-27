import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';

@Component({
  selector: 'page-events',
  templateUrl: 'events.html'
})
export class EventsPage {
  selectedItem: any;
  icons: string[];
  events: Array<{title: string, date: Date, type: string}>;

  constructor(public navCtrl: NavController, public navParams: NavParams) {
    // If we navigated to this page, we will have an item available as a nav param
    this.selectedItem = navParams.get('item');

    // Let's populate this page with some filler content for funzies
    this.icons = ['ios-trophy'];

    this.events = [
      {title: "Kappa Sig and Slide", date: new Date(2017, 8, 27), type: "Rush"},
      {title: "Lace Up and Salute", date: new Date(2017, 8, 27), type: "Philanthropy"},
      {title: "Mass Impact", date: new Date(2017, 8, 27), type: "Philanthropy"},
      {title: "Soap Hockey", date: new Date(2017, 8, 27), type: "Rush"}
    ]
  }

  itemTapped(event, item) {
    // That's right, we're pushing to ourselves!
    this.navCtrl.push(EventsPage, {
      item: item
    });
  }
}
