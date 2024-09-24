import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dungeoneers/app/constants.dart';
import 'package:dungeoneers/providers/system_settings.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  late SystemSettings _systemSettings;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _systemSettings = Provider.of<SystemSettings>(context, listen: false);
    _loadSelectedIndex();
  }

  Future<void> _loadSelectedIndex() async {
    final index = _systemSettings.appURLIndex;
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSelected(int index) async {
    _systemSettings.setAppURLIndex(index);
    await _systemSettings.storeAppURLIndex(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isTablet = screenSize.shortestSide >= 600;
    final containerHeight = screenSize.height *
        (isTablet ? 0.5 : 0.7); // 70% for tablet, 40% for phone
    final containerWidth =
        screenSize.width * 0.6; // 85% for tablet, 60% for phone

    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Colors.black87,
          height: containerHeight,
          width: containerWidth,
          alignment: Alignment.center,
          child: Column(
            children: [
              Flexible(
                flex: 0,
                child: Container(
                  color: Colors.grey,
                  height: 50,
                  width: containerWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 40),
                            child: Text(
                              'Debug Screen',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: Constants.appURLs.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        tileColor: Colors.black87,
                        title: Text(
                          Constants.appURLs[index],
                          style: TextStyle(fontSize: isTablet ? 20 : 16),
                        ),
                        onTap: () => _onSelected(index),
                        selected: index == _selectedIndex,
                        trailing: index == _selectedIndex
                            ? const Icon(Icons.check, color: Colors.orange)
                            : null,
                        selectedColor: Colors.orange,
                        textColor: Colors.white, // Add this
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
