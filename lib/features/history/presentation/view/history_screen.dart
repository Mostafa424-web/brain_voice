import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Recent Tab'),
    Text('History Tab'),
  ];

  final List<String> _recentWords = [
    'How are you',
    'How old are you',
    'I want to help you',
    'I like to study libras',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('History',
          style: TextStyle(
            color: Colors.black
          ),),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  child: Text(
                    'recent',
                    style: GoogleFonts.outfit(
                      textStyle: Styles.textStyle16.copyWith(color: Colors.black),),
                  ),
                ),
                Tab(
                  child: Text(
                    'Favourite',
                    style: GoogleFonts.outfit(
                      textStyle: Styles.textStyle16.copyWith(color: Colors.black),),
                  ),
                )
              ]),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(children: [
            Center(child: _buildRecentTab()),
            Center(child: _buildHistoryTab()),
          ]),
        ),
      ),
    );
  }

  Widget _buildRecentTab() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: _recentWords.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(_recentWords[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Text(
      'This is the History tab',
      style: TextStyle(fontSize: 24),
    );
  }
}