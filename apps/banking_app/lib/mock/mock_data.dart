/// Cuenta bancaria ficticia.
class MockAccount {
  const MockAccount({required this.name, required this.balanceCents});

  final String name;
  final int balanceCents;

  static const List<MockAccount> all = [
    MockAccount(name: 'Cuenta de ahorros', balanceCents: 452030),
    MockAccount(name: 'Cuenta corriente', balanceCents: 128075),
  ];
}

/// Tarjeta ficticia.
class MockCard {
  const MockCard({required this.label, required this.lastDigits, required this.limitCents});

  final String label;
  final String lastDigits;
  final int limitCents;

  static const List<MockCard> all = [
    MockCard(label: 'Tarjeta Débito', lastDigits: '4821', limitCents: 0),
    MockCard(label: 'Tarjeta Crédito Gold', lastDigits: '7735', limitCents: 500000),
  ];
}

/// Movimiento ficticio.
class MockMovement {
  const MockMovement({required this.title, required this.amountCents, required this.date});

  final String title;
  final int amountCents;
  final String date;

  static const List<MockMovement> all = [
    MockMovement(title: 'Supermercado La Central', amountCents: -8540, date: '18 sep'),
    MockMovement(title: 'Depósito de nómina', amountCents: 250000, date: '15 sep'),
    MockMovement(title: 'Envío a Ana Martínez', amountCents: -12000, date: '12 sep'),
    MockMovement(title: 'Café Rincón', amountCents: -540, date: '11 sep'),
  ];
}
