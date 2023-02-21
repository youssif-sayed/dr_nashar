abstract class PaymentState{}


class PaymentInitState extends PaymentState{}

class PaymentSuccessState extends PaymentState{}

class PaymentErrorState extends PaymentState{
  String error;
  PaymentErrorState(this.error);
}



class PaymentOrderIDSuccessState extends PaymentState{}

class PaymentOrderIDErrorState extends PaymentState{
  String error;
  PaymentOrderIDErrorState(this.error);
}

class PaymentRequestSuccessState extends PaymentState{}

class PaymentRequestErrorState extends PaymentState{
  String error;
  PaymentRequestErrorState(this.error);
}