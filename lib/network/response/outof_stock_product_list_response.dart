class OutofStockProductsResponse{
  int success;
  String message;
  List<Product> product;

  OutofStockProductsResponse({this.success, this.message, this.product});

  OutofStockProductsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['product'] != null) {
      product = new List<Product>();
      json['product'].forEach((v) {
        product.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.product != null) {
      data['product'] = this.product.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product{
  String code;
  int userId;
  int status;
  int parentId;
  int isShowInList;
  int taxClassId;
  String slug;
  int isFeatured;
  int isPuliAssured;
  int isBest;
  int isPreorder;
  String preorderStartdate;
  String preorderEnddate;
  String weight;
  String sizeChart;
  String orderNumber;
  int sortorderInVendorapp;
  String rewardPoint;
  String purchaseReward;
  String metaTitle;
  String metaDescription;
  String metaKeywords;
  String cgst;
  String sgst;
  String igst;
  String utgst;
  String cess;
  int isAlisonsAssured;
  String createdAt;
  String updatedAt;
  int isLatest;
  int productId;
  int languageId;
  String name;
  String description;
  String appDescription;
  String benefits;
  String storageUses;
  String tags;
  String defaultPrice;
  String stock;
  String minQuantity;
  String maxQuantity;
  String currentPrice;
  String cost;
  int returnPeriod;
  String commission;
  int stockAlertQuantity;
  String latitude;
  String longtitude;
  String image;
  String sign;
  String phoneNumber;
  String email;
  String freeShippingAmount;
  int isDefault;
  int type;
  String gstNumber;

  Product(
      {this.code,
        this.userId,
        this.status,
        this.parentId,
        this.isShowInList,
        this.taxClassId,
        this.slug,
        this.isFeatured,
        this.isPuliAssured,
        this.isBest,
        this.isPreorder,
        this.preorderStartdate,
        this.preorderEnddate,
        this.weight,
        this.sizeChart,
        this.orderNumber,
        this.sortorderInVendorapp,
        this.rewardPoint,
        this.purchaseReward,
        this.metaTitle,
        this.metaDescription,
        this.metaKeywords,
        this.cgst,
        this.sgst,
        this.igst,
        this.utgst,
        this.cess,
        this.isAlisonsAssured,
        this.createdAt,
        this.updatedAt,
        this.isLatest,
        this.productId,
        this.languageId,
        this.name,
        this.description,
        this.appDescription,
        this.benefits,
        this.storageUses,
        this.tags,
        this.defaultPrice,
        this.stock,
        this.minQuantity,
        this.maxQuantity,
        this.currentPrice,
        this.cost,
        this.returnPeriod,
        this.commission,
        this.stockAlertQuantity,
        this.latitude,
        this.longtitude,
        this.image,
        this.sign,
        this.phoneNumber,
        this.email,
        this.freeShippingAmount,
        this.isDefault,
        this.type,
        this.gstNumber});

  Product.fromJson(Map<String, dynamic> json) {
    code = json['code'].toString();
    userId = json['user_id'];
    status = json['status'];
    parentId = json['parent_id'];
    isShowInList = json['is_show_in_list'];
    taxClassId = json['tax_class_id'];
    slug = json['slug'].toString();
    isFeatured = json['is_featured'];
    isPuliAssured = json['is_puli_assured'];
    isBest = json['is_best'];
    isPreorder = json['is_preorder'];
    preorderStartdate = json['preorder_startdate'];
    preorderEnddate = json['preorder_enddate'];
    weight = json['weight'].toString();
    sizeChart = json['size_chart'].toString();
    orderNumber = json['order_number'].toString();
    sortorderInVendorapp = json['sortorder_in_vendorapp'];
    rewardPoint = json['reward_point'].toString();
    purchaseReward = json['purchase_reward'].toString();
    metaTitle = json['meta_title'].toString();
    metaDescription = json['meta_description'].toString();
    metaKeywords = json['meta_keywords'].toString();
    cgst = json['cgst'].toString();
    sgst = json['sgst'].toString();
    igst = json['igst'].toString();
    utgst = json['utgst'].toString();
    cess = json['cess'].toString();
    isAlisonsAssured = json['is_alisons_assured'];
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    isLatest = json['is_latest'];
    productId = json['product_id'];
    languageId = json['language_id'];
    name = json['name'].toString();
    description = json['description'].toString();
    appDescription = json['app_description'].toString();
    benefits = json['benefits'].toString();
    storageUses = json['storage_uses'].toString();
    tags = json['tags'].toString();
    defaultPrice = json['default_price'].toString();
    stock = json['stock'].toString();
    minQuantity = json['min_quantity'].toString();
    maxQuantity = json['max_quantity'].toString();
    currentPrice = json['current_price'].toString();
    cost = json['cost'].toString();
    returnPeriod = json['return_period'];
    commission = json['commission'].toString();
    stockAlertQuantity = json['stock_alert_quantity'];
    latitude = json['latitude'].toString();
    longtitude = json['longtitude'].toString();
    image = json['image'].toString();
    sign = json['sign'];
    phoneNumber = json['phone_number'].toString();
    email = json['email'].toString();
    freeShippingAmount = json['free_shipping_amount'].toString();
    isDefault = json['is_default'];
    type = json['type'];
    gstNumber = json['gst_number'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['parent_id'] = this.parentId;
    data['is_show_in_list'] = this.isShowInList;
    data['tax_class_id'] = this.taxClassId;
    data['slug'] = this.slug;
    data['is_featured'] = this.isFeatured;
    data['is_puli_assured'] = this.isPuliAssured;
    data['is_best'] = this.isBest;
    data['is_preorder'] = this.isPreorder;
    data['preorder_startdate'] = this.preorderStartdate;
    data['preorder_enddate'] = this.preorderEnddate;
    data['weight'] = this.weight;
    data['size_chart'] = this.sizeChart;
    data['order_number'] = this.orderNumber;
    data['sortorder_in_vendorapp'] = this.sortorderInVendorapp;
    data['reward_point'] = this.rewardPoint;
    data['purchase_reward'] = this.purchaseReward;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['meta_keywords'] = this.metaKeywords;
    data['cgst'] = this.cgst;
    data['sgst'] = this.sgst;
    data['igst'] = this.igst;
    data['utgst'] = this.utgst;
    data['cess'] = this.cess;
    data['is_alisons_assured'] = this.isAlisonsAssured;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_latest'] = this.isLatest;
    data['product_id'] = this.productId;
    data['language_id'] = this.languageId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['app_description'] = this.appDescription;
    data['benefits'] = this.benefits;
    data['storage_uses'] = this.storageUses;
    data['tags'] = this.tags;
    data['default_price'] = this.defaultPrice;
    data['stock'] = this.stock;
    data['min_quantity'] = this.minQuantity;
    data['max_quantity'] = this.maxQuantity;
    data['current_price'] = this.currentPrice;
    data['cost'] = this.cost;
    data['return_period'] = this.returnPeriod;
    data['commission'] = this.commission;
    data['stock_alert_quantity'] = this.stockAlertQuantity;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['image'] = this.image;
    data['sign'] = this.sign;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['free_shipping_amount'] = this.freeShippingAmount;
    data['is_default'] = this.isDefault;
    data['type'] = this.type;
    data['gst_number'] = this.gstNumber;
    return data;
  }
}
