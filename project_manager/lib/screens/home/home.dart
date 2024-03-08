import 'package:flutter/material.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/screens/project_detail_page.dart';
import 'package:project_manager/screens/admin_panel.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/services/database.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/shared/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  List<Project> _projects = [];
  List<Project> _filteredProjects = [];

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  void _fetchProjects() async {
    List<Project> projects = await _databaseService.fetchProjects();
    setState(() {
      _projects = projects;
      _filteredProjects = _filterProjects(projects, _searchController.text);
    });
  }

  List<Project> _filterProjects(List<Project> projects, String query) {
    return projects.where((project) {
      final titleLower = project.naziv.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();
  }

  void _searchProjects(String query) {
    setState(() {
      _filteredProjects = _filterProjects(_projects, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        toolbarHeight: isDesktop ? 100 : 60,
        title: Text(
          'Project Manager',
          style: TextStyle(fontSize: isDesktop ? 50 : 24,
                            fontWeight: FontWeight.w900,
),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: isDesktop ? _buildDesktopActions() : [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: !isDesktop ? _buildDrawer() : null,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isDesktop ? 16 : 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                hintStyle: TextStyle(fontSize: isDesktop ? 30 : 20),
              ),
              style: TextStyle(fontSize: isDesktop ? 30 : 20),
              onChanged: _searchProjects,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProjects.length,
              itemBuilder: (context, index) {
                Project project = _filteredProjects[index];
                return ListTile(
                  title: Text(
                    project.naziv,
                    style: TextStyle(
                      fontSize: isDesktop ? 32 : 18,
                    ),
                  ),
                  subtitle: Text(
                    project.adresa,
                    style: TextStyle(
                      fontSize: isDesktop ? 28 : 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProjectDetailPage(project: project)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDesktopActions() {
    return [
      FutureBuilder<String?>(
        future: _auth.getCurrentUserID(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            String userId = snapshot.data!;
            return FutureBuilder<String?>(
              future: _databaseService.getUserRole(userId),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (roleSnapshot.hasData) {
                  String? userRole = roleSnapshot.data;
                  if (userRole == 'admin' || userRole == 'moderator') {
                    return ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminPanel()),
                        );
                        _fetchProjects();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Administrator',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text(
                      'User role: $userRole',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    );
                  }
                } else {
                  return Text(
                    'Role data not available',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  );
                }
              },
            );
          } else {
            return Text(
              'No ID available',
              style: TextStyle(
                fontSize: 24,
              ),
            );
          }
        },
      ),
      SizedBox(width: 12),
      ElevatedButton.icon(
        icon: Icon(Icons.logout_rounded, color: Colors.black),
        label: Text(
          'Odjavi se',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        onPressed: () async {
          await _auth.signOut();
        },
      ),
    ];
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 70,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          FutureBuilder<String?>(
            future: _auth.getCurrentUserID(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                String userId = snapshot.data!;
                return FutureBuilder<String?>(
                  future: _databaseService.getUserRole(userId),
                  builder: (context, roleSnapshot) {
                    if (roleSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (roleSnapshot.hasData) {
                      String? userRole = roleSnapshot.data;
                      if (userRole == 'admin' || userRole == 'moderator') {
                        return ListTile(
                          title: Text('Administrator'),
                          onTap: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminPanel()),
                            );
                            _fetchProjects();
                          },
                        );
                      }
                    }
                    // Return an empty container if the user is not an administrator
                    return Container();
                  },
                );
              }
              // Return an empty container if user ID is not available
              return Container();
            },
          ),
          ListTile(
            title: Text('Log out'),
            onTap: () async {
              Navigator.pop(context);
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
