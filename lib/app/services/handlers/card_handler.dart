import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

class CardHandler {
  CardHandler._internal();
  static final CardHandler _cardServices = CardHandler._internal();
  factory CardHandler() => _cardServices;

  Future addCard({
    required PinextCardModel pinextCardModel,
    required bool duringSignIn,
  }) async {
    if (duringSignIn) {
      return await FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(FirebaseServices().getUserId())
          .collection('pinext_cards')
          .doc(pinextCardModel.cardId)
          .set(pinextCardModel.toMap());
    } else {
      PinextUserModel user = UserHandler().currentUser;
      double adjustedNetBalance = double.parse(user.netBalance) +
          double.parse(pinextCardModel.balance.toString());
      await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(FirebaseServices().getUserId())
          .update({
        "netBalance": adjustedNetBalance.toString(),
      });

      await FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(FirebaseServices().getUserId())
          .collection('pinext_cards')
          .doc(pinextCardModel.cardId)
          .set(pinextCardModel.toMap());
    }
  }

  removeCard(PinextCardModel pinextCardModel) async {
    PinextUserModel user = await UserHandler().getCurrentUser();
    double adjustedNetBalance = double.parse(user.netBalance) -
        double.parse(pinextCardModel.balance.toString());
    await UserHandler().updateNetBalance(adjustedNetBalance.toString());
    await FirebaseServices()
        .firebaseFirestore
        .collection(USERS_DIRECTORY)
        .doc(FirebaseServices().getUserId())
        .collection(CARDS_DIRECTORY)
        .doc(pinextCardModel.cardId)
        .delete();
    return;
  }

  editCard(PinextCardModel pinextCardModel) {}

  getCard(String cardId) async {
    PinextCardModel pinextCardModel;
    DocumentSnapshot cardSnapshot = await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_cards')
        .doc(cardId)
        .get();
    pinextCardModel =
        PinextCardModel.fromMap(cardSnapshot.data() as Map<String, dynamic>);
    return pinextCardModel;
  }

  updateCard(PinextCardModel newVersion) async {
    DocumentSnapshot userDocument = await FirebaseServices()
        .firebaseFirestore
        .collection(USERS_DIRECTORY)
        .doc(UserHandler().currentUser.userId)
        .collection(CARDS_DIRECTORY)
        .doc(newVersion.cardId)
        .get();
    PinextCardModel currentVersion =
        PinextCardModel.fromMap(userDocument.data() as Map<String, dynamic>);

    if (currentVersion.balance != newVersion.balance) {
      double currentNetBalance =
          double.parse(UserHandler().currentUser.netBalance);
      double adjustedNetBalance;
      if (currentVersion.balance > newVersion.balance) {
        double toBeAdjustedBalance =
            currentVersion.balance - newVersion.balance;
        adjustedNetBalance = currentNetBalance - toBeAdjustedBalance;
      } else {
        //  (currentVersion.balance < newVersion.balance)
        double toBeAdjustedBalance =
            newVersion.balance - currentVersion.balance;
        adjustedNetBalance = currentNetBalance + toBeAdjustedBalance;
      }
      await UserHandler().updateNetBalance(adjustedNetBalance.toString());
      log(newVersion.toString());
      await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(UserHandler().currentUser.userId)
          .collection(CARDS_DIRECTORY)
          .doc(newVersion.cardId)
          .update(newVersion.toMap());

      userDocument = await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(UserHandler().currentUser.userId)
          .collection(CARDS_DIRECTORY)
          .doc(newVersion.cardId)
          .get();
      currentVersion =
          PinextCardModel.fromMap(userDocument.data() as Map<String, dynamic>);
      log(currentVersion.toString());

      return;
    }
  }
}
