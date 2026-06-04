class PlantillaIa {
  final String id;
  final String prompt;
  final String contexto;

  PlantillaIa({required this.id, required this.prompt, required this.contexto});

  factory PlantillaIa.fromJson(Map<String, dynamic> json) => PlantillaIa(
        id: json['id'] as String? ?? 'main',
        prompt: json['prompt'] as String? ?? '',
        contexto: json['contexto'] as String? ?? '[]',
      );
}
