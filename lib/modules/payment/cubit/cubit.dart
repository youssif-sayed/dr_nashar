import 'package:bloc/bloc.dart';
import 'package:dr_nashar/const/payMob.dart';
import 'package:dr_nashar/models/first_token.dart';
import 'package:dr_nashar/modules/payment/cubit/states.dart';
import 'package:dr_nashar/shared/network/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitState());
  static PaymentCubit get(context) => BlocProvider.of(context);
  FirstToken? firstToken;


  Future getFirstToken(String price,String firstname,String lastname,String email,String phone) async {
    DioHelperPayment.postData(
        url: "auth/tokens", data: {"api_key": PayMobApiKey}).then((value) {
      PayMobFirstToken = value.data['token'];
      getOrderID(price, firstname, lastname, email, phone);
      emit(PaymentSuccessState());
    }).catchError((error) {
      emit(PaymentErrorState(error));
    });
  }

  Future getOrderID(String price,String firstname,String lastname,String email,String phone) async {
    DioHelperPayment.postData(url: "ecommerce/orders", data: {
      "auth_token": PayMobFirstToken,
      "delivery_needed": "false",
      "items": [],
      "amount_cents": price,
      "currency":"EGP",
    }).then((value) {
      PayMobOrderID = value.data['id'].toString();
      getFinalTokenCard(price, firstname, lastname, email, phone);
      emit(PaymentOrderIDSuccessState());
    }).catchError((error) {
      emit(PaymentOrderIDErrorState(error));
    });
  }

  Future getFinalTokenCard(String price,String firstname,String lastname,String email,String phone) async {
    DioHelperPayment.postData(url: "acceptance/payment_keys", data: {
        "auth_token": PayMobFirstToken,
        "amount_cents": price,
        "expiration": 3600,
        "order_id": PayMobOrderID,
        "billing_data": {
          "apartment": "na",
          "email": email,
          "floor": "na",
          "first_name": firstname,
          "street": "na",
          "building": "na",
          "phone_number": phone,
          "shipping_method": "na",
          "postal_code": "na",
          "city": "na",
          "country": "na",
          "last_name": lastname,
          "state": "na"
        },
        "currency": "EGP",
        "integration_id": IntgrationIDCard,


    }).then((value) {
      PaymobCardFinalToken = value.data['token'].toString();
      print(PaymobCardFinalToken);
      emit(PaymentRequestSuccessState());
    }).catchError((error) {
      emit(PaymentRequestErrorState(error));
    });
  }
}
