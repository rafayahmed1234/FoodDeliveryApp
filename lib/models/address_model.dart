class Address {
  final String id;
  final String name;
  final String fullAddress;
  final String? phone;

  Address({
    required this.id,
    required this.name,
    required this.fullAddress,
    this.phone,
  });
}