import 'package:capstone/constants/color.dart' as colors;
import 'package:capstone/constants/text.dart' as texts;
import 'package:capstone/model/load_data.dart';
import 'package:capstone/model/script.dart';
import 'package:capstone/widget/category_buttons.dart';
import 'package:capstone/widget/script/create_user_script_button.dart';
import 'package:capstone/widget/script/script_list_tile.dart';
import 'package:flutter/material.dart';

class ScriptList extends StatefulWidget {
  const ScriptList({
    Key? key,
    required this.index
  }) : super(key: key);

  final int index;

  @override
  State<ScriptList> createState() => _ScriptListState();
}

class _ScriptListState extends State<ScriptList> {
  final LoadData loadData = LoadData();
  String selectedCategoryValue = texts.category[0];

  void _handleCategorySelected(String value) {
    setState(() {
      selectedCategoryValue = value;
    });
  }


  Widget _readScripts(dynamic streamFunc){
    return StreamBuilder<List<ScriptModel>>(
        stream: streamFunc,
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            return ListView.builder(
                itemCount: snapshots.data!.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  ScriptModel script = snapshots.data![index];
                  return scriptListTile(context, script);
                });
        } else {
          return const SelectionArea(
            child: Center(
              child: Icon(Icons.hourglass_bottom)
            )
          );
        }
      })
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          color: colors.bgrDarkColor,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: CategoryButtons(onCategorySelected: _handleCategorySelected),
              ),
              widget.index == 0 ?
                Expanded(
                  child: _readScripts(loadData.readExampleScripts(selectedCategoryValue))
                )
                : Expanded(
                    child: Stack(
                      children:[
                        _readScripts(loadData.readUserScripts(selectedCategoryValue)),
                        Positioned(
                          bottom: 2,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05,
                          child: createUserScriptButton()
                        )
                    ])
                  )                    
          ])
        )
    );
  }
}