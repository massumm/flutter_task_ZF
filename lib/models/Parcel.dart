class Parcel {
  final String id;
  final String status;
  final String recipientName;
  final String recipientPhone;
  final String recipientCity;
  final String recipientArea;
  final String recipientAddress;
  final double amountToCollect;
  final String itemDescription;
  final int itemQuantity;
  final int itemWeight;

  Parcel({
    required this.id,
    required this.status,
    required this.recipientName,
    required this.recipientPhone,
    required this.recipientCity,
    required this.recipientArea,
    required this.recipientAddress,
    required this.amountToCollect,
    required this.itemDescription,
    required this.itemQuantity,
    required this.itemWeight,
  });
}
