import 'package:flutter/material.dart';

class Shope extends StatefulWidget {
  final String title;
  final String location;

  const Shope({
    Key? key,
    required this.title,
    required this.location,
  }) : super(key: key);

  @override
  State<Shope> createState() => _ShopeState();
}

class _ShopeState extends State<Shope> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ['All', 'Cars', 'Cabs', 'Van', 'Bikes'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTabContent(String tabName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: Text('$tabName Vehicle 1'),
              subtitle: const Text('Brand A'),
              leading: const Icon(Icons.directions_car),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('$tabName Vehicle 2'),
              subtitle: const Text('Brand B'),
              leading: const Icon(Icons.directions_car),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Image + More Info button
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 220,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text(
                            'Cover Image',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: -10,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(60, 30),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'More Info',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Location: ${widget.location}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tabs
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Color(0xFFE74D3D),
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Color(0xFFE74D3D),
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                    ),
                  ),

                  // Tab content
                  SizedBox(
                    height: 250,
                    child: TabBarView(
                      controller: _tabController,
                      children: tabs.map((tab) => buildTabContent(tab)).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Back Button
            Positioned(
              top: 10,
              left: 10,
              child: ClipOval(
                child: Material(
                  color: Colors.black.withOpacity(0.7),
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.2),
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
