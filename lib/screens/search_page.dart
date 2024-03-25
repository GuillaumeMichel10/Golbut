import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../models/establishment_model.dart';

class SearchPage extends StatefulWidget {
  final Future<List<Establishment>>? establishment;
  final Map<String, TextEditingController> textEditingControllerMap;

  final Function(String) onSelectedFilterChanged;
  final Function(String) onSelectedTownChanged;
  final Function(String) onSelectedNameChanged;

  const SearchPage({Key? key,
    required this.establishment,
    required this.textEditingControllerMap,
    required this.onSelectedFilterChanged,
    required this.onSelectedTownChanged,
    required this.onSelectedNameChanged
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedFilter;
  String? selectedTown;
  String? selectedName;

  @override
  void initState() {
    super.initState();
  }

  Future<Set<String>> _filterFilters() async {
    Set<String> filters = {};

    List<Establishment>? establishments = await widget.establishment;
    if (establishments != null) {
      for (var establishment in establishments) {
        establishment.filter?.forEach((filter) {
          filters.add(filter);
        });
      }
    }

    return filters;
  }

  Future<List<String>> _filterTowns(String search) async {
    List<String> filteredTowns = [];

    List<Establishment>? establishments = await widget.establishment;

    if (establishments != null) {
      Set<String> uniqueTowns = {};

      uniqueTowns.addAll(establishments
          .where((e) => e.filter?.contains(selectedFilter) ?? false)
          .map((e) => e.town!)
          .where((name) => name.toLowerCase().contains(search.toLowerCase())));

      filteredTowns = uniqueTowns.toList();
    }

    return filteredTowns;
  }

  Future<List<String>> _filterName(String search) async {
    List<String> filteredName = [];

    List<Establishment>? establishments = await widget.establishment;

    if (establishments != null) {
      Set<String> uniqueName = {};

      uniqueName.addAll(establishments
          .where((e) =>
      (e.filter?.contains(selectedFilter) ?? false) &&
          e.town == selectedTown)
          .map((e) => e.name!)
          .where((name) => name.toLowerCase().contains(search.toLowerCase())));

      filteredName = uniqueName.toList();
    }

    return filteredName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Bienvenue sur OpenHygiène',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'OpenHygiène est une application conçue pour vous aider à trouver des informations sur les établissements alimentaires en fonction de leur niveau d\'hygiène.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Vous pouvez rechercher des établissements par leur nom, leur adresse ou leur ville, et obtenir des informations détaillées sur leur niveau d\'hygiène.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildRatingSystem(),
              SizedBox(height: 20),
              TypeAheadField<String>(
                builder: (context, controller, focusNode) {
                  return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Filtre',
                      ));
                },
                controller: widget.textEditingControllerMap['filter'],
                itemBuilder: (BuildContext context, String value) {
                  return ListTile(
                    title: Text(value),
                  );
                },
                onSelected: (String value) {
                  setState(() {
                    widget.textEditingControllerMap['filter']?.text = value;
                    selectedFilter = value;
                  });
                  widget.onSelectedFilterChanged(value);
                },
                suggestionsCallback: (String search) {
                  return _filterFilters().then((filters) {
                    return filters
                        .where((filter) =>
                        filter.toLowerCase().contains(search.toLowerCase()))
                        .toList();
                  });
                },
                loadingBuilder: (BuildContext context) {
                  return const CircularProgressIndicator();
                },
                decorationBuilder: (context, child) {
                  return Material(
                    type: MaterialType.card,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: child,
                  );
                },
                offset: const Offset(0, 12),
                constraints: const BoxConstraints(maxHeight: 500),
              ),
              const SizedBox(height: 20),
              TypeAheadField<String>(
                builder: (context, controller, focusNode) {
                  return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Commune',
                      ));
                },
                controller: widget.textEditingControllerMap['town'],
                itemBuilder: (BuildContext context, String value) {
                  return ListTile(
                    title: Text(value),
                  );
                },
                onSelected: (String value) {
                  setState(() {
                    widget.textEditingControllerMap['town']?.text = value;
                    selectedTown = value;
                  });
                  widget.onSelectedTownChanged(value);
                },
                suggestionsCallback: (String search) {
                  return _filterTowns(search);
                },
                loadingBuilder: (BuildContext context) {
                  return const CircularProgressIndicator();
                },
                decorationBuilder: (context, child) {
                  return Material(
                    type: MaterialType.card,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: child,
                  );
                },
                offset: const Offset(0, 12),
                constraints: const BoxConstraints(maxHeight: 500),
              ),
              SizedBox(height: 20),
              TypeAheadField<String>(
                builder: (context, controller, focusNode) {
                  return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nom',
                      ));
                },
                controller: widget.textEditingControllerMap['name'],
                itemBuilder: (BuildContext context, String value) {
                  return ListTile(
                    title: Text(value),
                  );
                },
                onSelected: (String value) {
                  setState(() {
                    widget.textEditingControllerMap['name']?.text = value;
                    selectedName = value;
                  });
                  widget.onSelectedNameChanged(value);
                },
                suggestionsCallback: (String search) {
                  return _filterName(search);
                },
                loadingBuilder: (BuildContext context) {
                  return const CircularProgressIndicator();
                },
                decorationBuilder: (context, child) {
                  return Material(
                    type: MaterialType.card,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: child,
                  );
                },
                offset: const Offset(0, 12),
                constraints: const BoxConstraints(maxHeight: 500),
              ),
              SizedBox(height: 500),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRatingSystem() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildRatingItem(
        icon: Icons.done,
        color: Colors.green,
        title: 'Niveau d\'hygiène très satisfaisant',
        description:
        'Établissements ne présentant pas de non-conformité, ou présentant uniquement des non-conformités mineures.',
      ),
      _buildRatingItem(
        icon: Icons.warning,
        color: Colors.yellow,
        title: 'Niveau d\'hygiène satisfaisant',
        description:
        'Établissements présentant des non-conformités qui ne justifient pas l’adoption de mesures de police administrative mais auxquels l’autorité administrative adresse un courrier de rappel de la réglementation en vue d’une amélioration des pratiques.',
      ),
      _buildRatingItem(
        icon: Icons.warning,
        color: Colors.orange,
        title: 'Niveau d\'hygiène à améliorer',
        description:
        'Établissements dont l\'exploitant a été mis en demeure de procéder à des mesures correctives dans un délai fixé par l\'autorité administrative et qui conduit à un nouveau contrôle des services de l’État pour vérifier la mise en place de ces mesures correctives.',
      ),
      _buildRatingItem(
        icon: Icons.cancel,
        color: Colors.red,
        title: 'Niveau d\'hygiène à corriger de manière urgente',
        description:
        'Établissements présentant des non-conformités susceptibles de mettre en danger la santé du consommateur et pour lesquels l\'autorité administrative ordonne la fermeture administrative, le retrait, ou la suspension de l\'agrément sanitaire.',
      ),
    ],
  );
}

Widget _buildRatingItem({
  required IconData icon,
  required Color color,
  required String title,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
      ],
    ),
  );
}
