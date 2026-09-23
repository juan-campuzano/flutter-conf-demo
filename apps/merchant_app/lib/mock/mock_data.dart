/// Producto ficticio del catálogo del comercio.
class MockProduct {
  const MockProduct({required this.name, required this.priceCents});

  final String name;
  final int priceCents;

  static const List<MockProduct> all = [
    MockProduct(name: 'Café americano', priceCents: 3200),
    MockProduct(name: 'Croissant', priceCents: 4500),
    MockProduct(name: 'Jugo natural', priceCents: 5800),
  ];
}

enum MockOrderStatus { paid, pending, refunded, cancelled }

/// Orden ficticia del día.
class MockOrder {
  const MockOrder({required this.id, required this.totalCents, required this.status});

  final String id;
  final int totalCents;
  final MockOrderStatus status;

  static const List<MockOrder> all = [
    MockOrder(id: '#1042', totalCents: 12500, status: MockOrderStatus.paid),
    MockOrder(id: '#1043', totalCents: 8300, status: MockOrderStatus.pending),
    MockOrder(id: '#1044', totalCents: 4500, status: MockOrderStatus.refunded),
    MockOrder(id: '#1045', totalCents: 6200, status: MockOrderStatus.cancelled),
  ];
}
