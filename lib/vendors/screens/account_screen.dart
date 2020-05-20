import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/login_register.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var _isEditMode = false;

  Widget _infoField(label, initialValue, TextInputType inputType) => Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
          initialValue: initialValue,
          enabled: _isEditMode,
          decoration: InputDecoration(
            labelText: label,
          ),
          keyboardType: inputType,
          onSaved: (String value) {},
          validator: (String value) {
            return value.contains('@') ? 'Do not use the @ char.' : null;
          },
        ),
      );

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
              child: RaisedButton(
                child: Text("Save"),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: RaisedButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    _isEditMode = !_isEditMode;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _isEditMode = !_isEditMode;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Profile",
                      textScaleFactor: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                       ),
                    ),
                    GestureDetector(
                        child: Icon(
                            Icons.exit_to_app, color: Colors.white,size: 30.0,)   ,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                      },

                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          'https://www.shareicon.net/data/512x512/2016/07/26/802043_man_512x512.png',
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          //size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      !_isEditMode ? _getEditIcon() : SizedBox(),
                    ],
                  ),
                  _infoField("Name", "Matt Smith", TextInputType.text),
                  _infoField(
                      "Email", "msmith@gmail.com", TextInputType.emailAddress),
                  _infoField("Phone", "1234567890", TextInputType.phone),
                  _infoField(
                      "Address", "Bulk Road, Weston", TextInputType.text),
                  _isEditMode ? _getActionButtons() : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
