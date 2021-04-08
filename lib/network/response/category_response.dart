class CategoryResponse {
  // String storeId;
  List<Categories> categories;
  List<Specification> specification;
  List<Manufacturers> manufacturers;

  CategoryResponse.fromJson(dynamic json) {
    // storeId = json["store_id"].toString();
    if (json["categories"] != null) {
      categories = [];
      json["categories"].forEach((v) {
        categories.add(Categories.fromJson(v));
      });
    }
    if (json["specification"] != null) {
      specification = [];
      json["specification"].forEach((v) {
        specification.add(Specification.fromJson(v));
      });
    }
    if (json["manufacturers"] != null) {
      manufacturers = [];
      json["manufacturers"].forEach((v) {
        manufacturers.add(Manufacturers.fromJson(v));
      });
    }
  }
}

class Manufacturers {
  String id, image, slug, name;

  Manufacturers.fromJson(dynamic json) {
    id = json["id"].toString();
    image = json["image"];
    slug = json["slug"];
    name = json["name"];
  }
}

class Specification {
  String specificationId, name;
  List<SpecificationValue> values;

  Specification.fromJson(dynamic json) {
    specificationId = json["specification_id"].toString();
    name = json["name"];
    if (json["values"] != null) {
      values = [];
      json["values"].forEach((v) {
        values.add(SpecificationValue.fromJson(v));
      });
    }
  }
}

class SpecificationValue {
  String id;
  String name;

  SpecificationValue.fromJson(dynamic json) {
    id = json["id"].toString();
    name = json["name"];
  }
}

class Categories {
  String id, parentId, image, slug;
  // int orderNumber;
  Language language;
  List<Subcategorieslanguage> subcategorieslanguage;

  Categories.fromJson(dynamic json) {
    id = json["id"].toString();
    parentId = json["parent_id"].toString();
    // orderNumber = json["order_number"];
    image = json["image"];
    slug = json["slug"];
    language =
        json["language"] != null ? Language.fromJson(json["language"]) : null;
    if (json["subcategorieslanguage"] != null) {
      subcategorieslanguage = [];
      json["subcategorieslanguage"].forEach((v) {
        subcategorieslanguage.add(Subcategorieslanguage.fromJson(v));
      });
    }
  }
}

class Subcategorieslanguage {
  String id, name, parentId;

  Subcategorieslanguage.fromJson(dynamic json) {
    id = json["id"].toString();
    name = json["name"];
    parentId = json["parent_id"].toString();
  }
}

class Language {
  String categoryId, name;

  Language.fromJson(dynamic json) {
    categoryId = json["category_id"].toString();
    name = json["name"];
  }
}
