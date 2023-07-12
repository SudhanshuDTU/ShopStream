class ProductModel {
  String? sId;
  String? category;
  int? price;
  List<String>? images;
  String? title;
  String? description;
  String? updatedOn;
  String? createdOn;

  ProductModel(
      {this.sId,
      this.category,
      this.price,
      this.images,
      this.title,
      this.description,
      this.updatedOn,
      this.createdOn});

  ProductModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
    price = json['price'];
    images = json['images'].cast<String>();
    title = json['title'];
    description = json['description'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['category'] = this.category;
    data['price'] = this.price;
    data['images'] = this.images;
    data['title'] = this.title;
    data['description'] = this.description;
    data['updatedOn'] = this.updatedOn;
    data['createdOn'] = this.createdOn;
    return data;
  }
}
