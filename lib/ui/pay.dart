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

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({Key key}) : super(key: key);

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  List numberAsList = [];

  String money = '20';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 82, 230),
      appBar: appBar(),
      body: body(),
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 5,
      title: Text("Send Nano"),
      backgroundColor: Color.fromARGB(255, 3, 82, 230),
    );
  }

  Widget body() {
    return Column(
      children: [
        moneyWidget(),
        keypadWidget(),
        button(),
      ],
    );
  }

  Widget cardWithNumber() {
    return Row(
      children: [
        Icon(Icons.credit_card, color: Colors.grey, size: 18),
        Text(
          " **** 5064",
          //  text: "98765432105064".replaceRange(0,10," **** "),
        ),
      ],
    );
    // return RichText( this alignment is not satisfying
    //   text: TextSpan(
    //     children: [
    //       WidgetSpan(
    //         child: Icon(Icons.credit_card, color: Colors.grey),
    //       ),
    //       TextSpan(
    //         text: "98765432105064".replaceRange(0,10,"****"),
    //       ),
    //     ]
    //   ),
    // );
  }

  Widget moneyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: RichText(
//$
          text: TextSpan(
        text: '\$',
        style: TextStyle(
          fontSize: 60,
          color: Color.fromARGB(255, 153, 190, 222).withOpacity(0.5),
          fontWeight: FontWeight.w300,
        ),
        children: [
//20
          TextSpan(
            text: money,
            style: TextStyle(
              fontSize: 60,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
//.0
          if (money != '')
            TextSpan(
                text: '.0',
                style: TextStyle(
                  fontSize: 60,
                  color: Color.fromARGB(255, 153, 190, 222).withOpacity(0.5),
                  fontWeight: FontWeight.w300,
                )),
        ],
      )),
    );
  }

  Widget keypadWidget() {
    return Flexible(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 40,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: numbers.length,
        itemBuilder: (BuildContext context, int index) {
          int number = numbers[index];
          if (index == 9) return Container(height: 0, width: 0);
          return InkWell(
            borderRadius: BorderRadius.circular(360),
            onTap: () {
              if (index == 11) {
                try {
                  setState(() => money =
                      money.replaceRange(money.length - 1, money.length, ''));
                } catch (e) {
                  print("Error removing $e");
                }
              } else {
                setState(() => money = '$money$number');
              }
            },
            child: Container(
              child: index == 11
                  ? Icon(Icons.backspace,
                      color: Color.fromARGB(255, 255, 255, 255))
                  : Text('${number}'),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(95, 1, 87, 185),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: Container(
        height: 55,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Text(
          "Pay",
          style: TextStyle(
              color: Color.fromARGB(255, 2, 74, 134),
              fontWeight: FontWeight.bold),
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 253, 253),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, -1, 0, -1];
}
