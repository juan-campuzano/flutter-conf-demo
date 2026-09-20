/// Destinatario ficticio para la experiencia de envío de dinero.
class MockRecipient {
  const MockRecipient({required this.id, required this.name, required this.initials});

  final String id;
  final String name;
  final String initials;

  static const List<MockRecipient> sample = [
    MockRecipient(id: '1', name: 'Ana Martínez', initials: 'AM'),
    MockRecipient(id: '2', name: 'Carlos Ruiz', initials: 'CR'),
    MockRecipient(id: '3', name: 'Beatriz Soto', initials: 'BS'),
    MockRecipient(id: '4', name: 'Diego Campuzano', initials: 'DC'),
  ];
}
