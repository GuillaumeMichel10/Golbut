import 'package:flutter/material.dart';
import '../models/establishment_model.dart';

class ResultPage extends StatefulWidget {
  final Future<List<Establishment>>? establishment;
  final String? selectedFilter;
  final String? selectedTown;
  final String? selectedName;

  const ResultPage({Key? key,
    required this.establishment,
    required this.selectedFilter,
    required this.selectedTown,
    required this.selectedName,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Future<List<Establishment>>? filteredEstablishments;

  @override
  void initState() {
    super.initState();
    filteredEstablishments = filterEstablishments();
  }

  @override
  void didUpdateWidget(ResultPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFilter != widget.selectedFilter ||
        oldWidget.selectedTown != widget.selectedTown ||
        oldWidget.selectedName != widget.selectedName) {
      setState(() {
        filteredEstablishments = filterEstablishments();
      });
    }
  }

  Future<List<Establishment>> filterEstablishments() async {
    List<Establishment> establishments = await widget.establishment!;

    establishments = establishments.where((establishment) {
      bool filterMatch = widget.selectedFilter != null ? establishment.filter
          ?.contains(widget.selectedFilter!) ?? false : true;
      bool townMatch = widget.selectedTown != null ? establishment.town ==
          widget.selectedTown : true;
      bool nameMatch = widget.selectedName != null ? establishment.name ==
          widget.selectedName : true;

      return filterMatch && townMatch && nameMatch;
    }).toList();

    print(widget.selectedFilter);
    print(widget.selectedTown);
    print(widget.selectedName);


    return establishments;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Establishment>>(
        future: filteredEstablishments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Establishment> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Establishment establishment = data[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(establishment.name ?? ""),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Adresse: ${establishment.address ?? ""}"),
                                Text("Code Postal: ${establishment.postalCode ??
                                    ""}"),
                                Text("Ville: ${establishment.town ?? ""}"),
                                // Ajoutez ici d'autres informations que vous souhaitez afficher
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: establishment.score == "Très satisfaisant"
                              ? const Icon(Icons.done, color: Colors.green)
                              : establishment.score == "Satisfaisant"
                              ? const Icon(Icons.warning, color: Colors.yellow)
                              : establishment.score == "A améliorer"
                              ? const Icon(Icons.warning, color: Colors.orange)
                              : const Icon(Icons.cancel, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}