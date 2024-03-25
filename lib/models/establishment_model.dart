import 'package:http/http.dart' as http;
import 'dart:convert';

class Establishment {
  final String? name;
  final String? siret;
  final String? address;
  final String? postalCode;
  final String? town;
  final String? inspectionNumber;
  final String? inspectionDate;
  final String? score;
  final List<String>? filter;

  Establishment({
    required this.name,
    required this.siret,
    required this.address,
    required this.postalCode,
    required this.town,
    required this.inspectionNumber,
    required this.inspectionDate,
    required this.score,
    this.filter,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      name: json['app_libelle_etablissement'],
      siret: json['siret'],
      address: json['adresse_2_ua'],
      postalCode: json['code_postal'],
      town: json['libelle_commune'],
      inspectionNumber: json['numero_inspection'],
      inspectionDate: json['date_inspection'],
      score: json['synthese_eval_sanit'],
      filter: json['filtre'] != null ? List<String>.from(json['filtre']) : null,
    );
  }
}

Future<List<Establishment>> fetchEstablishment() async {
  final uri = Uri.https(
    'dgal.opendatasoft.com',
    '/api/explore/v2.1/catalog/datasets/export_alimconfiance/exports/json',
    {
      'select':
      'app_libelle_etablissement,siret,adresse_2_ua,code_postal,libelle_commune,date_inspection,synthese_eval_sanit,filtre',
    },
  );
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Establishment.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load etablissements from API');
  }
}
