class DashboardResponse {
  // int success;
  DashboardData dashboardData;
  DashboardResponse.fromJson(Map<String, dynamic> json) {
    // success = json['success'];
    if (json['data'] != null) {
      dashboardData = DashboardData.fromJson(json['data']);
    }
  }
}

class DashboardData {
  String orderCount,
      newOrderCount,
      cancelledCount,
      deliveredCount,
      returnedCount,
      productsCount,
      rejectedCount,
      newOrderTotal,
      deliveredTotal,
      rejectedTotal,
      returnedTotal,
      cancelledTotal,
      pending,
      storeslug,
      followers,
      year;
  List<SalesChartData> salesChart;
  DashboardData.fromJson(Map<String, dynamic> json) {
    orderCount = json['orderCount'].toString();
    newOrderCount = json['newordercount'].toString();
    storeslug = json['storeslug'].toString();
    cancelledCount = json['cancelledcount'].toString();
    returnedCount = json['returnedcount'].toString();
    deliveredCount = json['deliveredcount'].toString();
    productsCount = json['productscount'].toString();
    // productApprovalCount = json['productapprovalcount'].toString();
    rejectedCount = json['rejectedcount'].toString();
    newOrderTotal = json['neworder_total'].toString();
    deliveredTotal = json['delivered_total'].toString();
    rejectedTotal = json['rejected_total'].toString();
    returnedTotal = json['returned_total'].toString();
    cancelledTotal = json['cancelled_total'].toString();
    pending = json['pending'].toString();
    year = json['year'].toString();
    followers = json['followers'].toString();
    if (json['graph'] != null) {
      salesChart = (json['graph'] as List)
          .map((reasonsJson) => SalesChartData.fromJson(reasonsJson))
          .toList();
    }
  }
}

class SalesChartData {
  String month, amount;
  SalesChartData.fromJson(Map<String, dynamic> json) {
    month = json['month'].toString();
    amount = json['amount'].toString();
  }
}
