import 'package:equatable/equatable.dart';
import 'package:frontend/data/models/cart/cart_item_model.dart';
import 'package:frontend/data/models/user/user_model.dart';

class OrderModel extends Equatable {
  String? sId;
  String? status;
  UserModel? user;
  List<CartItemModel>? items;
  DateTime? updatedOn;
  DateTime? createdOn;
  String? razorPayOrderId;
  double? totalAmount;

  OrderModel(
      {this.sId,
      this.status,
      this.updatedOn,
      this.createdOn,
      this.items,
      this.user,
      this.razorPayOrderId,
      this.totalAmount});

  OrderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = UserModel.fromJson(json["user"]);
    items = (json["items"] as List<dynamic>)
        .map((singleItem) => CartItemModel.fromJson(singleItem))
        .toList();
    status = json['status'];
    razorPayOrderId = json['razorPayOrderId'];
    totalAmount = double.tryParse(json['totalAmount'].toString());
    updatedOn = DateTime.tryParse(json['updatedOn']);
    createdOn = DateTime.tryParse(json['createdOn']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = user!.toJson();
    data['items'] = items!
        .map((singleItem) => singleItem.toJson(objectMode: true))
        .toList();
    data['status'] = this.status;
    data['razorPayOrderId'] = this.razorPayOrderId;
    data['totalAmount'] = this.totalAmount;
    data['updatedOn'] = this.updatedOn?.toIso8601String();
    data['createdOn'] = this.createdOn?.toIso8601String();
    return data;
  }

  @override
  List<Object?> get props => [sId];
}
