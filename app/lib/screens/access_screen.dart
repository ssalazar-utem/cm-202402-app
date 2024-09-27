import 'package:cm/models/access.dart';
import 'package:cm/services/rest_service.dart';
import 'package:cm/widgets/barra_app.dart';
import 'package:cm/widgets/menu_app.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class _AccessScreenState extends State<AccessScreen> {
  static final Logger _logger = Logger();
  List<Access> _accessList = [];

  Future<void> _refresh() async {
    _accessList = await RestService.access();
    setState(() {
      if (mounted) {
        _logger.d('Recreando la vista');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BarraApp(titulo: 'Accesos'),
        drawer: const MenuApp(),
        body: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                itemCount: _accessList.length,
                itemBuilder: (context, index) {
                  final Access access = _accessList[index];
                  return Card(
                    margin: const EdgeInsets.all(7),
                    child: ListTile(
                      title: Text('Fecha ${access.created}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('URL: ${access.requestUri}'),
                          Text('Dispositivo: ${access.userAgent}'),
                          Text('IP: ${access.ip}')
                        ],
                      ),
                    ),
                  );
                })));
  }

  @override
  void dispose() {
    _accessList.clear();
    super.dispose();
  }
}

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccessScreenState();
}
