import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class PayHereService {
  // Method to initialize payment
  static Future<void> makePayment({
    required bool isSandbox,
    required String merchantId,
    required String merchantSecret,
    required String orderId,
    required String items,
    required String amount,
    required String currency,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String country,
    String? notifyUrl,
    String? deliveryAddress,
    String? deliveryCity,
    String? deliveryCountry,
    String? custom1,
    String? custom2,
    Function(String)? onSuccess,
    Function(String)? onError,
    Function()? onDismiss,
  }) async {
    // Define the payment object
    Map paymentObject = {
      "sandbox": isSandbox,  // true if using sandbox environment
      "merchant_id": merchantId,
      "merchant_secret": merchantSecret,
      "order_id": orderId,
      "items": items,
      "amount": amount,  // Amount to be paid
      "currency": currency,  // e.g. LKR, USD, etc.
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "address": address,
      "city": city,
      "country": country,
      "notify_url": notifyUrl ?? "",  // Optional, notify URL for backend
      "delivery_address": deliveryAddress ?? "",
      "delivery_city": deliveryCity ?? "",
      "delivery_country": deliveryCountry ?? "",
      "custom_1": custom1 ?? "",
      "custom_2": custom2 ?? "",
    };

    try {
      // Start the payment process
      PayHere.startPayment(
          paymentObject,
              (paymentId) {
            if (onSuccess != null) {
              onSuccess(paymentId);
            }
          },
              (error) {
            if (onError != null) {
              onError(error);
            }
          },
              () {
            if (onDismiss != null) {
              onDismiss();
            }
          }
      );
    } catch (e) {
      // Handle exceptions
      if (onError != null) {
        onError(e.toString());
      }
    }
  }
}
