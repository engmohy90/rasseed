 import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:rasseed/main.dart';
import 'package:rasseed/screens/UI/DataEdit.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String langSelected = "اللغه العربيه";
  String temp = "";
  List<String> langList = ['اوردو','اللغه الانجليزيه','اللغه العربيه'];

  GlobalKey<ScaffoldState> settingScaffoldKey = GlobalKey();
  showLangList(){
    showDialog(
        context: context,
      builder: (context)=>AlertDialog(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text("تغير اللغه",style: TextStyle(color: Colors.black,fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text("حدد اللغه المفضله اليك؟",style: TextStyle(color: Colors.black,fontSize: 15),),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 15.0),
                child: RadioButtonGroup(

                  activeColor: Color.fromRGBO(69, 57, 137, 1.0),
                    labels: <String>[
                      "اوردو",
                      "اللغه الانجليزيه",
                      "اللغه العربيه",
                    ],
                    onSelected: (String selected) {
                      setState(() {
                        temp = selected;
                      });
                    }
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 40.0),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            langSelected = temp;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("تغير",style: TextStyle(fontSize: 16,color: Color.fromRGBO(69, 57, 137, 1.0),fontWeight: FontWeight.w300),),
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Text("اغلاق",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w300),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  logoutUser(){
    showDialog(
        context: context,
      builder: (context)=>AlertDialog(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          height: MediaQuery.of(context).size.height/4,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text("هل تريد تسجيل الخروج؟",style: TextStyle(color: Colors.black,fontSize: 20),),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 40.0),
                      child: InkWell(
                        onTap: () async {
                          Loader.showUnDismissibleLoader(context);
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.clear().then((dataCleared){
                            if(dataCleared)
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MyApp()), (Route<dynamic> route) => false);
                            else{
                              Loader.hideDialog(context);
                              settingScaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Container(  width: MediaQuery.of(context).size.width,child: Text('فشل تسجيل الخروج!',textAlign: TextAlign.center,)),
                              ));
                            }
                          });
                        },
                        child: Text("خروج",style: TextStyle(fontSize: 16,color: Colors.red,fontWeight: FontWeight.normal),),
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Text("إلغاء",style: TextStyle(fontSize: 16,color: Color.fromRGBO(69, 57, 137, 1.0),fontWeight: FontWeight.w300),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: settingScaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text("الاعدادات",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.white,size: 20.0,), onPressed: (){
            Navigator.pop(context);
          }),
        ],
        leading: Container(
          color: Color.fromRGBO(69, 57, 137, 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20.0,left: 15,right: 15.0),
                child: InkWell(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  onTap: (){
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new DataEdit()));
                    print("sasa");
                  },
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Icon(Icons.arrow_back_ios,size: 25,color: Colors.black,)
                        ),
                        Container(
                          child: Text("البيانات الشخصيه",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black.withOpacity(1),fontSize: 20),),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.withOpacity(.5),
                height: .5,
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0,left: 15,right: 15.0),
                child: InkWell(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  onTap: (){
                    showLangList();
                    print("sasa");
                  },
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Text("${langSelected}",style: TextStyle(fontSize: 18,color: Colors.grey.withOpacity(.7)),)
                        ),
                        Container(
                          child: Text("اللغه",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black.withOpacity(1),fontSize: 20),),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.withOpacity(.5),
                height: .5,
              ),

              Container(
                margin: EdgeInsets.only(top: 20.0,left: 15,right: 15.0),
                child: InkWell(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  onTap: (){
                    logoutUser();
                  },
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Text("تسجيل خروج",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.red.withOpacity(1),fontSize: 20),),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
