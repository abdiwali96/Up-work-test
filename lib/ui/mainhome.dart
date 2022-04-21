import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:logger/logger.dart';
import 'package:manta_dart/manta_wallet.dart';
import 'package:manta_dart/messages.dart';
import 'package:natrium_wallet_flutter/model/db/account.dart';
import 'package:natrium_wallet_flutter/network/model/response/alerts_response_item.dart';
import 'package:natrium_wallet_flutter/network/model/response/subscribe_response.dart';
import 'package:natrium_wallet_flutter/ui/home_page.dart';
import 'package:natrium_wallet_flutter/ui/payreceive.dart';
import 'package:natrium_wallet_flutter/ui/pay.dart';
import 'package:natrium_wallet_flutter/ui/popup_button.dart';
import 'package:natrium_wallet_flutter/appstate_container.dart';
import 'package:natrium_wallet_flutter/dimens.dart';
import 'package:natrium_wallet_flutter/localization.dart';
import 'package:natrium_wallet_flutter/service_locator.dart';
import 'package:natrium_wallet_flutter/model/address.dart';
import 'package:natrium_wallet_flutter/model/list_model.dart';
import 'package:natrium_wallet_flutter/model/db/contact.dart';
import 'package:natrium_wallet_flutter/model/db/appdb.dart';
import 'package:natrium_wallet_flutter/network/model/block_types.dart';
import 'package:natrium_wallet_flutter/network/model/response/account_history_response_item.dart';
import 'package:natrium_wallet_flutter/styles.dart';
import 'package:natrium_wallet_flutter/app_icons.dart';
import 'package:natrium_wallet_flutter/ui/contacts/add_contact.dart';
import 'package:natrium_wallet_flutter/ui/send/send_sheet.dart';
import 'package:natrium_wallet_flutter/ui/send/send_confirm_sheet.dart';
import 'package:natrium_wallet_flutter/ui/receive/receive_sheet.dart';
import 'package:natrium_wallet_flutter/ui/settings/settings_drawer.dart';
import 'package:natrium_wallet_flutter/ui/widgets/buttons.dart';
import 'package:natrium_wallet_flutter/ui/widgets/dialog.dart';
import 'package:natrium_wallet_flutter/ui/widgets/remote_message_card.dart';
import 'package:natrium_wallet_flutter/ui/widgets/remote_message_sheet.dart';
import 'package:natrium_wallet_flutter/ui/widgets/sheet_util.dart';
import 'package:natrium_wallet_flutter/ui/widgets/list_slidable.dart';
import 'package:natrium_wallet_flutter/ui/util/routes.dart';
import 'package:natrium_wallet_flutter/ui/widgets/reactive_refresh.dart';
import 'package:natrium_wallet_flutter/ui/util/ui_util.dart';
import 'package:natrium_wallet_flutter/ui/widgets/transaction_state_tag.dart';
import 'package:natrium_wallet_flutter/util/manta.dart';
import 'package:natrium_wallet_flutter/util/sharedprefsutil.dart';
import 'package:natrium_wallet_flutter/util/hapticutil.dart';
import 'package:natrium_wallet_flutter/util/caseconverter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:natrium_wallet_flutter/bus/events.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'contacts.dart';

class mainhome extends StatefulWidget {
  const mainhome({key}) : super(key: key);

  @override
  State<mainhome> createState() => _mainhomeState();
}

class _mainhomeState extends State<mainhome> {
  int selectedPage = 1;

  final _pageOptions = [AppHomePage(), paysendpage(), contact()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: _pageOptions[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics, size: 30), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.payment, size: 30), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.contacts, size: 30), label: ''),
          ],
          selectedItemColor: Color.fromARGB(255, 76, 127, 175),
          elevation: 5.0,
          unselectedItemColor: Color.fromARGB(255, 27, 62, 94),
          currentIndex: selectedPage,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
        ));
  }
}
