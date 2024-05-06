import 'package:earthquake/providers/app_data_provider.dart';
import 'package:earthquake/settings_page.dart';
import 'package:earthquake/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    Provider.of<AppDataProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquakes'),
        actions: [
          IconButton(
            onPressed: _showSortingDialog,
            icon: Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage())),
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) => provider.hasDataloaded
            ? provider.earthquakeModel!.features!.isEmpty
                ? Center(
                    child: Text('No record found'),
                  )
                : ListView.builder(
                    itemCount: provider.earthquakeModel!.features!.length,
                    itemBuilder: (context, index) {
                      final data = provider
                          .earthquakeModel!.features![index].properties!;
                      return ListTile(
                        title: Text(data.place ?? data.title ?? 'unknown'),
                        subtitle: Text(getFormattedDateTime(
                            data.time!, 'EEE MMM dd yyyy hh:mm a ')),
                        trailing: Chip(
                          avatar: data.alert == null
                              ? null
                              : CircleAvatar(
                                  backgroundColor:
                                      provider.getAlertColor(data.alert!),
                                ),
                          label: Text('${data.mag}'),
                        ),
                      );
                    },
                  )
            : Center(
                child: Text('please wait'),
              ),
      ),
    );
  }

  void _showSortingDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Sort by'),
              content: Consumer<AppDataProvider>(
                builder: (context, provider, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioGroup(
                      groupValue: provider.orderBy,
                      value: 'magnitude',
                      label: 'Magnitude-Desc',
                      onChange: (value) {
                        provider.setOrder(value!);
                      },
                    ),
                    RadioGroup(
                      groupValue: provider.orderBy,
                      value: 'magnitude-asc',
                      label: 'Magnitude-Asc',
                      onChange: (value) {
                        provider.setOrder(value!);
                      },
                    ),
                    RadioGroup(
                      groupValue: provider.orderBy,
                      value: 'time',
                      label: 'Time-Desc',
                      onChange: (value) {
                        provider.setOrder(value!);
                      },
                    ),
                    RadioGroup(
                      groupValue: provider.orderBy,
                      value: 'time-asc',
                      label: 'Time-Asc',
                      onChange: (value) {
                        provider.setOrder(value!);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('close'),
                )
              ],
            ));
  }
}

class RadioGroup extends StatelessWidget {
  final String groupValue;
  final String value;
  final String label;
  final Function(String?) onChange;

  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.value,
    required this.label,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(label)
      ],
    );
  }
}
