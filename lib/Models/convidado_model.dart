class Guest {
  final String id;
  final String name;
  final String email;
  final String statusPresenca; // Novo campo

  Guest({
    required this.id,
    required this.name,
    required this.email,
    required this.statusPresenca,
  });

  // Converte um Guest para um Map (útil para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'statusPresenca': statusPresenca,
    };
  }

  // Converte um Map para um Guest (útil para ler do Firestore)
  factory Guest.fromMap(String id, Map<String, dynamic> data) {
    return Guest(
      id: id,
      name: data['name'],
      email: data['email'],
      statusPresenca: data['statusPresenca'] ?? 'esperando', // Valor padrão
    );
  }
}