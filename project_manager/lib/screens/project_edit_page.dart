import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/services/database.dart';

class ProjectEditPage extends StatefulWidget {
  final Project project;

  ProjectEditPage({required this.project});

  @override
  _ProjectEditPageState createState() => _ProjectEditPageState();
}

class _ProjectEditPageState extends State<ProjectEditPage> {
  late TextEditingController _nazivController;
  late TextEditingController _adresaController;

  @override
  void initState() {
    super.initState();
    _nazivController = TextEditingController(text: widget.project.naziv);
    _adresaController = TextEditingController(text: widget.project.adresa);
  }

  @override
  void dispose() {
    _nazivController.dispose();
    _adresaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Project'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nazivController,
              decoration: InputDecoration(labelText: 'Project Name'),
            ),
            TextFormField(
              controller: _adresaController,
              decoration: InputDecoration(labelText: 'Project Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
      
              // Inside onPressed callback of the "Save Changes" button in ProjectEditPage
// Inside onPressed callback of the "Save Changes" button in ProjectEditPage
                onPressed: () async {
                  // Get updated project information from text controllers
                  String updatedNaziv = _nazivController.text;
                  String updatedAdresa = _adresaController.text;

                  try {
                    // Update the naziv and adresa properties in the database
                    await DatabaseService().updateProjectNaziv(widget.project.id, updatedNaziv);
                    await DatabaseService().updateProjectAdresa(widget.project.id, updatedAdresa);

                    // Update the naziv and adresa properties in the local project object
                    widget.project.naziv = updatedNaziv;
                    widget.project.adresa = updatedAdresa;

                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  } catch (e) {
                    // Handle errors
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to update project: $e'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },




              
              child: Text('Save Changes'),

            ),
          ],
        ),
      ),
    );
  }
}

