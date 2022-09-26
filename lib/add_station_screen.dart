import 'package:flutter/material.dart';

import 'http_services/station.dart';

class AddStationScreen extends StatefulWidget {
  const AddStationScreen({Key? key, required this.cards}) : super(key: key);
  final List<Widget> cards;

  @override
  _AddStationScreenState createState() => _AddStationScreenState(cards: cards);
}

class _AddStationScreenState extends State<AddStationScreen> {
  _AddStationScreenState({required this.cards});
  final List<Widget> cards;
  final _formKey = GlobalKey<FormState>();
  final _textInputController = TextEditingController();
  bool _validStation = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Add Station'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: _textInputController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter station name',
                ),
                validator: (value){
                  if(value == null || value.isEmpty || !_validStation){
                    return 'Please enter valid station name';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    Station? station = await Station.getStation(_textInputController.text);
                    setState(() {
                      _isLoading = false;
                    });

                    //Checks if a valid station was returned
                    if(station != null){
                      _validStation = true;
                    } else {
                      _validStation = false;
                    }

                    if(!mounted) return;

                    if(_formKey.currentState!.validate()){
                      //Text field is valid
                      Navigator.pop(context,
                        station,
                      );
                    }
                  },
                  child: const Text('Submit')),
              if(_isLoading) const Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(value: null,),),
            ],
          ),
        ),
      ),
    );
  }
}


