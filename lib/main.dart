import 'package:flutter/material.dart';
import 'package:practice/Db.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
 State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final db = Db() ;

  final formState  = GlobalKey<FormState>() ;

  final TextEditingController userNameController = TextEditingController() ;
  final TextEditingController emailController = TextEditingController() ;
  final TextEditingController passwordController = TextEditingController();
  String lastDelete = " ";
List<Map<String,dynamic>> resultText = [] ;
  @override
      Widget build(BuildContext context){
    return MaterialApp(
      title:'MyApp',
      home:Scaffold(
        appBar:AppBar(
          title: const Text("preparing .."),
        ),
        body:   Column(
            children:[
              Container(
                padding: EdgeInsets.all(20),
                child:Form(
                  key:formState ,
                  child:Column(
                        children: [
                          TextFormField(
                            controller: userNameController,
                          decoration:InputDecoration(
                            fillColor:Colors.grey,
                            filled:true,
                            labelText:"Username",
                            prefixIcon: Icon(Icons.person),
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(10),
                            ),
                          ),

                        ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: emailController,
                            decoration:InputDecoration(
                                fillColor: Colors.grey,
                              filled:true,
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.greenAccent),
                              prefixIcon: Icon(Icons.email_outlined,color: Colors.red),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                            ),

                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            obscureText: true,
                             controller:  passwordController,
                            decoration:InputDecoration(
                                  prefixIcon:Icon(Icons.password),
                                    labelText:'password',
                                border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                            ),

                          ),
                                        SizedBox(height: 12,),
                          MaterialButton(
                            onPressed: () async {
                              if(userNameController.text.length < 3 ){
                                print('Non Valid Lenght');
                                return ;
                              }
                              if(emailController.text.length < 5 ||
                                  !emailController.text.contains('@'))
                              {
                                print("email Not validA");
                                return ;
                              }
                              await db.addUser(userNameController.text,emailController.text) ;
                               List<Map<String,dynamic>> users  = await db.getUsers() ;
                              print("Fetched users: $users");


                              print("userName :  " + userNameController.text.trim());
                              print("userName :  " + emailController.text.trim());
                              print("userName :  " + passwordController.text.trim());
                              SharedPreferences prefs = await SharedPreferences.getInstance();

                              await  prefs.setString("lastDelete",emailController.text);
                              setState((){
                                resultText  = users ;
                                //'user Nmae : ${userNameController.text.trim()}\n'
                                  //            'user Nmae : ${emailController.text.trim()}\n'
                                    //          'user Nmae : ${passwordController.text.trim()}\n' ;
                                lastDelete =  prefs.getString("lastDelete") ?? 'geust';
                              });
                            },

                            color: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(7),
                            child: Text("Register",style: TextStyle(
                              color:Colors.blueAccent,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,

                            ),),
                          ),

                        ],
                    ),
                ),
              ),
              Expanded(
                child: resultText.isEmpty
                    ? Center(child: Text("No users"))
                    : ListView.builder(
                  itemCount: resultText.length,
                  itemBuilder: (context, index) {
                    final user = resultText[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: ListTile(
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever,
                          color:Colors.red,
                          ),
                          onPressed : () async {
                            await db.destroy(user["name"]) ;
                            print("deleting from main : "+ user['name'] +" ..." );
                            List<Map<String,dynamic>> users  = await db.getUsers() ;
                            setState(() {
                              resultText = users ;

                            });

                          }
                      ),
                      ),
                    );
                  },
                ),
              ),
              Text(  lastDelete),
            ],
          ),
      ),
    );
  }
  
}


