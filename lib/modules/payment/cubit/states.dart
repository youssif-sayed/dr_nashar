abstract class PaymentState{}


class PaymentInitState extends PaymentState{}

class PaymentSuccessState extends PaymentState{}

class PaymentErrorState extends PaymentState{
  var error;
  PaymentErrorState(this.error);
}



class PaymentOrderIDSuccessState extends PaymentState{}

class PaymentOrderIDErrorState extends PaymentState{
  var error;
  PaymentOrderIDErrorState(this.error);
}

class PaymentRequestSuccessState extends PaymentState{}

class PaymentRequestErrorState extends PaymentState{
  var error;
  PaymentRequestErrorState(this.error);
}


class PaymentRequestKioskSuccessState extends PaymentState{}

class PaymentRequestKioskErrorState extends PaymentState{
  var error;
  PaymentRequestKioskErrorState(this.error);
}

class RefCodeSuccessState extends PaymentState{}

class RefCodeErrorState extends PaymentState{
  var error;
  RefCodeErrorState(this.error);
}