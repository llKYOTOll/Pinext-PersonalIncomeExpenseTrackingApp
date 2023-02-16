import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';

part 'add_subscription_state.dart';

class AddSubscriptionCubit extends Cubit<AddSubscriptionState> {
  AddSubscriptionCubit()
      : super(
          AddSubscriptionDefaultState(
            amount: '000',
            title: "",
            description: "",
            automaticallyPayActivated: false,
            selectedCardNo: "",
            alreadyPaid: "",
          ),
        );

  selectCard(String selectedCardNo) {
    emit(
      AddSubscriptionDefaultState(
        selectedCardNo: selectedCardNo,
        title: state.title,
        description: state.description,
        amount: state.amount,
        automaticallyPayActivated: state.automaticallyPayActivated,
        alreadyPaid: state.alreadyPaid,
      ),
    );
  }

  toogleAutomaticallyPaySwitch(bool value) {
    emit(
      AddSubscriptionDefaultState(
        selectedCardNo: state.selectedCardNo,
        title: state.title,
        description: state.description,
        amount: state.amount,
        automaticallyPayActivated: value,
        alreadyPaid: state.alreadyPaid,
      ),
    );
  }

  addSubscription(
    PinextSubscriptionModel pinextSubscriptionModel,
  ) async {
    emit(
      AddSubscriptionLoadingState(
        title: pinextSubscriptionModel.title,
        description: pinextSubscriptionModel.description,
        amount: pinextSubscriptionModel.amount,
        automaticallyPayActivated: pinextSubscriptionModel.automaticallyDeductEnabled,
        selectedCardNo: pinextSubscriptionModel.assignedCardId,
        alreadyPaid: state.alreadyPaid,
      ),
    );
    await Future.delayed(
      const Duration(seconds: 2),
    );
    emit(
      AddSubscriptionDefaultState(
        title: pinextSubscriptionModel.title,
        description: pinextSubscriptionModel.description,
        amount: pinextSubscriptionModel.amount,
        automaticallyPayActivated: pinextSubscriptionModel.automaticallyDeductEnabled,
        selectedCardNo: pinextSubscriptionModel.assignedCardId,
        alreadyPaid: state.alreadyPaid,
      ),
    );
  }

  changeAlreadyPaidStatus(String status) {
    emit(
      AddSubscriptionDefaultState(
        selectedCardNo: state.selectedCardNo,
        title: state.title,
        description: state.description,
        amount: state.amount,
        automaticallyPayActivated: state.automaticallyPayActivated,
        alreadyPaid: status,
      ),
    );
  }
}
