import 'package:dr_nashar/const/payMob.dart';
import 'package:dr_nashar/models/first_token.dart';
import 'package:dr_nashar/modules/payment/cubit/states.dart';
import 'package:dr_nashar/shared/network/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitState());
  static PaymentCubit get(context) => BlocProvider.of(context);
  FirstToken? firstToken;

  Future getFirstToken(String price, String firstname, String lastname,
      String email, String phone, isCard) async {
    DioHelperPayment.postData(
        url: "auth/tokens", data: {"api_key": PayMobApiKey}).then((value) {
      PayMobFirstToken = value.data['token'];
      print('First token : $PayMobFirstToken');
      price = '${price}00';
      getOrderID(price, firstname, lastname, email, phone, isCard);
      emit(PaymentSuccessState());
    }).catchError((error) {
      emit(PaymentErrorState(error));
    });
  }

  Future getOrderID(String price, String firstname, String lastname,
      String email, String phone, isCard) async {
    DioHelperPayment.postData(url: "ecommerce/orders", data: {
      "auth_token": PayMobFirstToken,
      "delivery_needed": "false",
      "items": [],
      "amount_cents": price,
      "currency": "EGP",
    }).then((value) {
      PayMobOrderID = value.data['id'].toString();
      print('OrderID : $PayMobOrderID');
      if (isCard) {
        getFinalTokenCard(price, firstname, lastname, email, phone);
      } else {
        getFinalTokenKiosk(price, firstname, lastname, email, phone);
      }
      emit(PaymentOrderIDSuccessState());
    }).catchError((error) {
      emit(PaymentOrderIDErrorState(error));
    });
  }

  Future getFinalTokenCard(String price, String firstname, String lastname,
      String email, String phone) async {
    DioHelperPayment.postData(url: "acceptance/payment_keys", data: {
      "auth_token": PayMobFirstToken,
      "amount_cents": price,
      "expiration": 3600,
      "order_id": PayMobOrderID,
      "billing_data": {
        "apartment": "NA",
        "email": email,
        "floor": "NA",
        "first_name": firstname,
        "street": "NA",
        "building": "NA",
        "phone_number": phone,
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "CR",
        "last_name": lastname,
        "state": "Utah"
      },
      "currency": "EGP",
      "integration_id": IntgrationIDCard,
      "lock_order_when_paid": "false"
    }).then((value) {
      PaymobCardFinalToken = value.data['token'].toString();
      print('Final token: $PaymobCardFinalToken');
      emit(PaymentRequestSuccessState());
    }).catchError((error) {
      print('error final token :$error');
      emit(PaymentRequestErrorState(error));
    });
  }

  Future getFinalTokenKiosk(String price, String firstname, String lastname,
      String email, String phone) async {
    DioHelperPayment.postData(url: "acceptance/payment_keys", data: {
      "auth_token": PayMobFirstToken,
      "amount_cents": price,
      "expiration": 3600,
      "order_id": PayMobOrderID,
      "billing_data": {
        "apartment": "NA",
        "email": email,
        "floor": "NA",
        "first_name": firstname,
        "street": "NA",
        "building": "NA",
        "phone_number": phone,
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "CR",
        "last_name": lastname,
        "state": "Utah"
      },
      "currency": "EGP",
      "integration_id": IntgrationIDKiosk,
      "lock_order_when_paid": "false"
    }).then((value) {
      KioskFinalToken = value.data['token'].toString();
      print('Final token kiosk: $KioskFinalToken');
      getRefCode(price, firstname, lastname, email, phone);
      emit(PaymentRequestKioskSuccessState());
    }).catchError((error) {
      print('error final token kiosk:$error');
      emit(PaymentRequestKioskErrorState(error));
    });
  }

  Future getRefCode(String price, String firstname, String lastname,
      String email, String phone) async {
    DioHelperPayment.postData(url: "acceptance/payments/pay", data: {
      "source": {"identifier": "AGGREGATOR", "subtype": "AGGREGATOR"},
      "payment_token": KioskFinalToken
    }).then((value) {
      RefCode = value.data['id'].toString();
      print('Ref Code: $RefCode');
      emit(RefCodeSuccessState());
    }).catchError((error) {
      print('Erorr Ref Code :$error');
      emit(RefCodeErrorState(error));
    });
  }
}
