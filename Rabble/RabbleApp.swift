//
//  RabbleApp.swift
//  Rabble
//
//  Created by Ben Davis on 10/10/2023.
//

import SwiftUI
import Nuke

@main
struct RabbleApp: App {

  init() {
    print("Setting up app...")
    ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}


//if ( passtype.etopID > 0 || ( passtype.PassID > 0 && passtype.utoe_PassID == passtype.PassID ) ) { // If pass is valid for this event or pass has been used for this event

//if (passtype.PassID>0) { // Pass (rather than passtype)
//} else { // Passtype, to be purchased

//if ( passtype.utoeID > 0 && passtype.utoe_PassID == passtype.PassID ) { // This particular pass is in use



//------------------
//if ( passtype.etopID > 0 || ( passtype.PassID > 0 && passtype.utoe_PassID == passtype.PassID ) ) { // If pass is valid for this event or pass has been used for this event
//  if (passtype.PassID>0) { // Pass (rather than passtype)
//
//    if ( passtype.utoeID > 0 && passtype.utoe_PassID == passtype.PassID ) { // This particular pass is in use
//      jQuery('#makesweat_assets #ms_dlgcp_passinuse').show();
//      console.log( "Pass in use" );
//      jQuery('#makesweat_assets #ms_dlgcp_passinuse>div').html(ms_core.renderpasstype(passtype));
//      return;
//    }
//
//    jQuery('#dialogchoosepassgot').append(sz);
//    got++;
//  } else { // Passtype, to be purchased
//    if ( passtype.Codehash != 0 ) {
//      withcode = 1;
//      notgot ++ ;
//
//      if ( passtype.Codehash == hash ) {
//        codefound = 1;
//      } else {
//        continue; // Skip this passtype
//      }
//    }
//    if ( ( passtype.Onceonly > 0 ) && ( passtype.Typeused >= passtype.Onceonly ) ) { continue; } // Skip if Onceonly is set
//    if ( passtype.Notforsale == 1 ) { continue; } // Skip from new pass list if not for sale
//
//    jQuery('#dialogchoosepassnotgot').append(sz);
//    notgot++;
//  }
//}
//}
