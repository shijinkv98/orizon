class ProductListResponse {
  // int success;
  // String message;
  List<ProductsWithCat> products;
  List<Images>images;
  ProductListResponse.fromJson(dynamic json) {
    // success = json["success"];
    // message = json["message"];
    if (json["products"] != null) {
      products = [];
      json["products"].forEach((v) {
        products.add(ProductsWithCat.fromJson(v));
      });
    }
    if (json["images"] != null) {
      images = [];
      json["images"].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
  }
}

class ProductsWithCat {
  String categoryId, name, description;
  PaginationData products;
  Category category;

  ProductsWithCat.fromJson(dynamic json) {
    categoryId = json["category_id"].toString();
    name = json["name"];
    description = json["description"];
    products = json["products"] != null
        ? PaginationData.fromJson(json["products"])
        : null;
    category =
        json["category"] != null ? Category.fromJson(json["category"]) : null;
  }
}

class Category {
  String id, parentId, orderNumber;
  String image, status;
  String slug;
  // int isPuliExpress;
  // int isPuliAssured;
  // int isAlisonsAssured;
  // int isAlisonsExpress;
  // int isVisibleInHome;
  // int isTryAndBuyAvailable;
  String metaTitle;
  dynamic metaDescription;
  dynamic metaKeywords;
  String createdAt;
  String updatedAt;

  Category.fromJson(dynamic json) {
    id = json ["id"].toString();
    parentId = json["parent_id"].toString();
    orderNumber = json["order_number"].toString();
    image = json["image"];
    status = json["status"].toString();
    slug = json["slug"];
    // isPuliExpress = json["is_puli_express"];
    // isPuliAssured = json["is_puli_assured"];
    // isAlisonsAssured = json["is_alisons_assured"];
    // isAlisonsExpress = json["is_alisons_express"];
    // isVisibleInHome = json["is_visible_in_home"];
    // isTryAndBuyAvailable = json["is_try_and_buy_available"];
    metaTitle = json["meta_title"];
    metaDescription = json["meta_description"];
    metaKeywords = json["meta_keywords"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}

class PaginationData {
  // int currentPage;
  List<Product> data;
  // int from;
  // int lastPage;
  String nextPageUrl;
  String path;
  // int perPage;
  dynamic prevPageUrl;
  // int to;
  // int total;

  PaginationData.fromJson(dynamic json) {
    data = [];
    for(int i=0;i<json.length;i++)
      {
        data.add(Product.fromJson(json[i]));
      }

    // currentPage = json["current_page"];
    // if (json["data"] != null) {
    //   data = [];
    //   json["data"].forEach((v) {
    //     data.add(Product.fromJson(v));
    //   });
    // }
    // from = json["from"];
    // lastPage = json["last_page"];
    // nextPageUrl = json["next_page_url"];
    // path = json["path"];
    // // perPage = json["per_page"];
    // prevPageUrl = json["prev_page_url"];
    // to = json["to"];
    // total = json["total"];
  }
}

class Product {
  String slug;
  int status;
  String storeslug;
  String purchaseReward;
  String rewardPoint;
  String productId;
  String code;
  String name;
  String appDescription;
  String description;
  String editproduct;
  String symbolLeft;
  String symbolRight, orderNumber;
  String defaultPrice;
  String cost, returnPeriod;
  String rejectionNote;
  String stock;
  String minQuantity;
  String tags, categoryId, categoryParentId, isShowInList;
  String currentPrice;
  String image;
  String store;
  String manufacturer;
  String productactivation;
  List<Images>images;
  List<Specifications> specifications;
  // List<dynamic> images;

  Product.fromJson(dynamic json) {
    slug = json["slug"];
    status = json["status"];
    storeslug = json["storeslug"];
    purchaseReward = json["purchase_reward"];
    productId = json["product_id"].toString();
    rewardPoint = json["reward_point"];
    code = json["code"];
    name = json["name"];
    rejectionNote = json['rejection_note'];
    appDescription = json["app_description"];
    description = json["description"];
    symbolLeft = json["symbol_left"];
    symbolRight = json["symbol_right"];
    orderNumber = json["order_number"].toString();
    defaultPrice = json["default_price"];
    cost = json["cost"];
    returnPeriod = json["return_period"].toString();
    stock = json["stock"];
    editproduct = json["editproduct"];
    minQuantity = json["min_quantity"];
    productactivation = json["productactivation"];
    tags = json["tags"];
    categoryId = json["category_id"].toString();
    categoryParentId = json["category_parent_id"].toString();
    isShowInList = json["is_show_in_list"].toString();
    currentPrice = json["current_price"];
    image = json["image"];
    store = json["store"];
    manufacturer = json["manufacturer"];
    if (json["specifications"] != null) {
      specifications = [];
      json["specifications"].forEach((v) {
        specifications.add(Specifications.fromJson(v));
      });
    }
    if (json["product_images"] != null) {
      images = [];
      json["product_images"].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    else
      {
        images = [];
      }
    // if (json["images"] != null) {
    //   images = []; 
    //   json["images"].forEach((v) {
    //     images.add(dynamic.fromJson(v));
    //   });
    // }
  }

  toJson() {}
}

class Images {
  String image;
  Images.fromJson(dynamic json) {
    image = json["image"].toString();
  }
}

class Specifications {
  String id, productId, specificationId;
  String createdAt;
  String updatedAt;
  Specification_ specification;
  List<Values> values;

  Specifications.fromJson(dynamic json) {
    id = json["id"].toString();
    productId = json["product_id"].toString();
    specificationId = json["specification_id"].toString();
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    specification = json["specification"] != null
        ? Specification_.fromJson(json["specification"])
        : null;
    if (json["values"] != null) {
      values = [];
      json["values"].forEach((v) {
        values.add(Values.fromJson(v));
      });
    }
  }
}

class Values {
  String id, productSpecificationId, specificationValueId;
  String createdAt;
  String updatedAt;
  List<Languages> languages;

  Values.fromJson(dynamic json) {
    id = json["id"].toString();
    productSpecificationId = json["product_specification_id"].toString();
    specificationValueId = json["specification_value_id"].toString();
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    if (json["languages"] != null) {
      languages = [];
      json["languages"].forEach((v) {
        languages.add(Languages.fromJson(v));
      });
    }
  }
}

class Languages {
  String id, specificationValueId, languageId;
  String value;
  String createdAt;
  String updatedAt;

  Languages.fromJson(dynamic json) {
    id = json["id"].toString();
    specificationValueId = json["specification_value_id"].toString();
    languageId = json["language_id"].toString();
    value = json["value"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}

class Specification_ {
  String id, specificationGroupId, inQuickview, inFilter;
  int status;
  String createdAt;
  String updatedAt;
  Language language;

  Specification_.fromJson(dynamic json) {
    id = json["id"].toString();
    specificationGroupId = json["specification_group_id"].toString();
    inQuickview = json["in_quickview"].toString();
    inFilter = json["in_filter"].toString();
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    language =
        json["language"] != null ? Language.fromJson(json["language"]) : null;
  }
}

class Language {
  String id, specificationId, languageId;
  String name;
  String createdAt;
  String updatedAt;

  Language.fromJson(dynamic json) {
    id = json["id"].toString();
    specificationId = json["specification_id"].toString();
    languageId = json["language_id"].toString();
    name = json["name"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
