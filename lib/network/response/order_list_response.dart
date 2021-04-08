class OrdersListResponse {
  // int success;
  _OrderStausData ordersData;
  OrdersListResponse.fromJson(Map<String, dynamic> json) {
    // success = json['success'];
    if (json['data'] != null) {
      ordersData = _OrderStausData.fromJson(json['data']);
    }
  }
}

class _OrderStausData {
  List<OrderStaus> orders;
  _OrderStausData.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = (json['orders'] as List)
          .map((reasonsJson) => OrderStaus.fromJson(reasonsJson))
          .toList();
    }
  }
}

class OrderStaus {
  String status;
  OrderPagination orderPagination;
  OrderStaus.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    if (json['list'] != null) {
      orderPagination = OrderPagination.fromJson(json['list']);
    }
  }
}

class OrderPagination {
  String nextPageUrl;
  List<Order> orders;
  OrderPagination.fromJson(Map<String, dynamic> json) {
    nextPageUrl = json['next_page_url'].toString();
    if (json['data'] != null) {
      orders = (json['data'] as List)
          .map((reasonsJson) => Order.fromJson(reasonsJson))
          .toList();
    }
  }
  List<OrderItems> getOrderItems() {
    List<OrderItems> orderItems = [];
    orders.forEach((element) {
      var items=element.itemsNew;
      orderItems.addAll(element.itemsNew.map((e) => OrderItems(element, e)));
    });
    return orderItems;
  }
}

class OrderItems {
  final Order orderData;
  final _Items item;
  OrderItems(this.orderData, this.item);
}

class Order {
  String id;
  String invoiceNumber, storeId, storeName;
  // int customerId, billingAddressId;
  String billingAddressType, billingName, billingEmail, billingPhone;
  String billingAddress, billingCity, billingState, billingCountry;
  String billingZipcode, billingLatitude, billingLongitude;
  // int shippingAddressId;
  String shippingAddressType, shippingName, shippingEmail;
  String shippingPhone, shippingAddress, shippingCity;
  String shippingState, shippingCountry, shippingZipcode;
  String shippingLatitude, shippingLongitude;
  String comments;
  // int cartId;
  String totalAmount;
  // String couponId, couponCode;
  String couponDiscount;
  // String couponDiscountType;
  String discountAmount;
  String walletAmount;
  String shippingCharge;
  String totalTaxAmount;
  String netTotalAmount;
  String paymentMode;
  String deliveryMode;
  String pickupStoreId;
  // String languageId, currencyId, currencyValue;
  String orderStatusId;
  String orderStatus;
  String paymentStatus;
  String orderCancelReason;
  String orderCancelDescription;
  String createdAt;
  String updatedAt;
  String orderWalletAmount;
  String orderTotalAmount;
  String orderNetTotalAmount;
  String orderShippingCharge;
  List<_Items> itemsNew;
  // List<dynamic> walletUsed;
  // List<dynamic> walletCancelled;
  // List<dynamic> walletReturned;

  Order.fromJson(dynamic json) {
    id = json["id"].toString();
    invoiceNumber = json["invoice_number"];
    storeId = json["store_id"].toString();
    storeName = json["store_name"];
    // customerId = json["customer_id"];
    // billingAddressId = json["billing_address_id"];
    billingAddressType = json["billing_address_type"];
    billingName = json["billing_name"];
    billingEmail = json["billing_email"];
    billingPhone = json["billing_phone"];
    billingAddress = json["billing_address"];
    billingCity = json["billing_city"];
    billingState = json["billing_state"];
    billingCountry = json["billing_country"];
    billingZipcode = json["billing_zipcode"];
    billingLatitude = json["billing_latitude"];
    billingLongitude = json["billing_longitude"];
    // shippingAddressId = json["shipping_address_id"];
    shippingAddressType = json["shipping_address_type"];
    shippingName = json["shipping_name"];
    shippingEmail = json["shipping_email"];
    shippingPhone = json["shipping_phone"];
    shippingAddress = json["shipping_address"];
    shippingCity = json["shipping_city"];
    shippingState = json["shipping_state"];
    shippingCountry = json["shipping_country"];
    shippingZipcode = json["shipping_zipcode"];
    shippingLatitude = json["shipping_latitude"];
    shippingLongitude = json["shipping_longitude"];
    comments = json["comments"];
    // cartId = json["cart_id"];
    totalAmount = json["total_amount"].toString();
    // couponId = json["coupon_id"];
    // couponCode = json["coupon_code"];
    couponDiscount = json["coupon_discount"];
    // couponDiscountType = json["coupon_discount_type"];
    discountAmount = json["discount_amount"];
    walletAmount = json["wallet_amount"].toString();
    shippingCharge = json["shipping_charge"].toString();
    totalTaxAmount = json["total_tax_amount"].toString();
    netTotalAmount = json["net_total_amount"].toString();
    paymentMode = json["payment_mode"].toString();
    deliveryMode = json["delivery_mode"].toString();
    pickupStoreId = json["pickup_store_id"].toString();
    // languageId = json["language_id"].toString();
    // currencyId = json["currency_id"].toString();
    // currencyValue = json["currency_value"].toString();
    orderStatusId = json["order_status_id"].toString();
    orderStatus = json["order_status"].toString();
    paymentStatus = json["payment_status"].toString();
    orderCancelReason = json["order_cancel_reason"];
    orderCancelDescription = json["order_cancel_description"];
    createdAt = json["created_at"].toString();
    updatedAt = json["updated_at"].toString();
    orderWalletAmount = json["order_wallet_amount"].toString();
    orderTotalAmount = json["order_total_amount"].toString();
    orderNetTotalAmount = json["order_net_total_amount"].toString();
    orderShippingCharge = json["order_shipping_charge"].toString();
    if (json["items"] != null) {
      itemsNew = [];
      json["items"].forEach((v) {
        itemsNew.add(_Items.fromJson(v));
      });
    }
    // if (json["wallet_used"] != null) {
    //   walletUsed = [];
    //   json["wallet_used"].forEach((v) {
    //     walletUsed.add(dynamic.fromJson(v));
    //   });
    // }
    // if (json["wallet_cancelled"] != null) {
    //   walletCancelled = [];
    //   json["wallet_cancelled"].forEach((v) {
    //     walletCancelled.add(dynamic.fromJson(v));
    //   });
    // }
    // if (json["wallet_returned"] != null) {
    //   walletReturned = [];
    //   json["wallet_returned"].forEach((v) {
    //     walletReturned.add(dynamic.fromJson(v));
    //   });
    // }
  }
  String getShippingAddress() {
    return '($shippingAddressType) $shippingAddress, $shippingCity, $shippingState, $shippingCountry'
        .replaceAll(', ,', ',')
        .replaceAll('  ', ' ')
        .replaceAll(' ,', ',')
        .trim();
  }
}

class _Items {
  String id, orderId;
  String sellerInvoiceReference;
  String itemCgst;
  String itemSgst;
  String itemIgst;
  String itemUtgst;
  String itemCess;
  String shippingCgst;
  String shippingSgst;
  String shippingIgst;
  String shippingUtgst;
  String shippingCess;
  int productId;
  int storeId;
  // dynamic paidToSellerReference;
  String sellerRefundAmount;
  String paidAmountToAdmin;
  String paidToAdmin;
  // dynamic paidToAdminDate;
  // dynamic paidToAdminReference;
  String productName;
  String quantity;
  String amount;
  String taxAmount;
  dynamic couponAmount;
  int itemStatus;
  String shippingCharge;
  // int returnPeriod;
  String refundPayable;
  String refundPayed;
  // dynamic refundBankId;
  // dynamic refundBankDetails;
  String itemCancelReason;
  String itemCancelDescription;
  // String cgst;
  // String sgst;
  // String igst;
  // String utgst;
  // String cess;
  // String createdAt;
  // String updatedAt;
  String slug;
  // int status;
  String stock;
  String image;
  int possibleAction;
  String statusText;
  // dynamic refund;
  // Product product;

  _Items.fromJson(dynamic json) {
    id = json["id"].toString();
    orderId = json["order_id"].toString();
    sellerInvoiceReference = json["seller_invoice_reference"];
    itemCgst = json["item_cgst"];
    itemSgst = json["item_sgst"];
    itemIgst = json["item_igst"];
    itemUtgst = json["item_utgst"];
    itemCess = json["item_cess"];
    shippingCgst = json["shipping_cgst"];
    shippingSgst = json["shipping_sgst"];
    shippingIgst = json["shipping_igst"];
    shippingUtgst = json["shipping_utgst"];
    shippingCess = json["shipping_cess"];
    productId = json["product_id"];
    storeId = json["store_id"];
    // paidToSellerReference = json["paid_to_seller_reference"];
    sellerRefundAmount = json["seller_refund_amount"];
    paidAmountToAdmin = json["paid_amount_to_admin"];
    paidToAdmin = json["paid_to_admin"].toString();
    // paidToAdminDate = json["paid_to_admin_date"];
    // paidToAdminReference = json["paid_to_admin_reference"];
    productName = json["product_name"];
    quantity = json["quantity"];
    amount = json["amount"];
    taxAmount = json["tax_amount"];
    couponAmount = json["coupon_amount"];
    itemStatus = json["item_status"];
    shippingCharge = json["shipping_charge"];
    // returnPeriod = json["return_period"];
    refundPayable = json["refund_payable"];
    refundPayed = json["refund_payed"];
    // refundBankId = json["refund_bank_id"];
    // refundBankDetails = json["refund_bank_details"];
    itemCancelReason = json["item_cancel_reason"];
    itemCancelDescription = json["item_cancel_description"];
    // cgst = json["cgst"];
    // sgst = json["sgst"];
    // igst = json["igst"];
    // utgst = json["utgst"];
    // cess = json["cess"];
    // createdAt = json["created_at"];
    // updatedAt = json["updated_at"];
    slug = json["slug"];
    // if(json["status"] is int){
    // status = json["status"];
    // }
    stock = json["stock"];
    image = json["image"];
    possibleAction = json["possible_action"];
    statusText = json["status_text"];
    // refund = json["refund"];
    // product =
    //     json["product"] != null ? Product.fromJson(json["product"]) : null;
  }
}

// class Product {
//   String code;
//   int userId;
//   int status;
//   int parentId;
//   int isShowInList;
//   int taxClassId;
//   String slug;
//   int isFeatured;
//   int isPuliAssured;
//   String weight;
//   String sizeChart;
//   int orderNumber;
//   String rewardPoint;
//   String purchaseReward;
//   String metaTitle;
//   String metaDescription;
//   dynamic metaKeywords;
//   String cgst;
//   String sgst;
//   String igst;
//   String utgst;
//   String cess;
//   int isAlisonsAssured;
//   String createdAt;
//   String updatedAt;
//   int isLatest;
//   List<dynamic> thisOptions;

//   Product.fromJson(dynamic json) {
//     code = json["code"];
//     userId = json["user_id"];
//     status = json["status"];
//     parentId = json["parent_id"];
//     isShowInList = json["is_show_in_list"];
//     taxClassId = json["tax_class_id"];
//     slug = json["slug"];
//     isFeatured = json["is_featured"];
//     isPuliAssured = json["is_puli_assured"];
//     weight = json["weight"];
//     sizeChart = json["size_chart"];
//     orderNumber = json["order_number"];
//     rewardPoint = json["reward_point"];
//     purchaseReward = json["purchase_reward"];
//     metaTitle = json["meta_title"];
//     metaDescription = json["meta_description"];
//     metaKeywords = json["meta_keywords"];
//     cgst = json["cgst"];
//     sgst = json["sgst"];
//     igst = json["igst"];
//     utgst = json["utgst"];
//     cess = json["cess"];
//     isAlisonsAssured = json["is_alisons_assured"];
//     createdAt = json["created_at"];
//     updatedAt = json["updated_at"];
//     isLatest = json["is_latest"];
//     if (json["this_options"] != null) {
//       thisOptions = [];
//       json["this_options"].forEach((v) {
//         thisOptions.add(dynamic.fromJson(v));
//       });
//     }
//   }
// }

class OrderDetailsResponse {
  List<Timeline> timeline;
  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['timeline'] != null) {
      timeline = (json['timeline'] as List)
          .map((reasonsJson) => Timeline.fromJson(reasonsJson))
          .toList();
    }
  }
}

class Timeline {
  String description, createdAt;
  StatusHistory statusHistory;
  Timeline.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    statusHistory = StatusHistory.fromJson(json['statushistory']);
    createdAt = json['created_at'];
  }
}

class StatusHistory {
  String statusText;
  StatusHistory.fromJson(Map<String, dynamic> json) {
    statusText = json['status_text'];
  }
}
