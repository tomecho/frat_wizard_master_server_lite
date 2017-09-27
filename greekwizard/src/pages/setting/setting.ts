import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';

@Component({
  selector: 'page-setting',
  templateUrl: 'setting.html'
})
export class SettingPage {
  settings: Array<{settingOption: string, status: boolean}>

  constructor(public navCtrl: NavController) {
    this.settings= [
      {settingOption:"Wifi", status:true},
      {settingOption:"Private",status:false},
      {settingOption:"Single",status:false},
      {settingOption:"Executive Member",status:false}
    ]
  }

}
