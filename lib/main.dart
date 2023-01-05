import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';


void main() {
  runApp(MaterialApp(
      home: MyApp()
    )
  );
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contact = await ContactsService.getContacts();
      setState(() {
        name = contact;
      });
      // print(contact[0].~~~); ~~는 걍 쓴거임
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }


  var total = 3;
  var a = 1;
  List<Contact> name = [];
  addOne(){
    setState(() {
      total++;
    });
  }
  addName(nameData){
    setState(() {
      name.add(nameData);
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI(sname : name[0], addOne : addOne, addName : addName);
            });
          },
        ),
        appBar: AppBar(title: Text(total.toString()), actions: [
          IconButton(onPressed: (){
            getPermission();
          }, icon: Icon(Icons.contacts))
        ],),
        body: ListView.builder(
          itemCount: name.length,
          itemBuilder: (c, i){
            return ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text(name[i].givenName ?? '이름없는놈'),
            );
          },
        ),


        bottomNavigationBar: Shop(),
      );


  }
}
class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.sname, this.addOne, this.addName}) : super(key: key);
  var sname;
  final addOne;
  final addName;
  var inputData = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField( controller: inputData, ),
            TextButton(onPressed:(){
              var newContact = Contact();
              newContact.givenName = inputData.text;  //새로운 연락처 만들기
              ContactsService.addContact(newContact);  //실제로 연락처에 집어넣기
              addName(newContact);
              }, child: Text('완료')),
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text('취소'))
          ],
        ),
      ),
    );
  }
}


class Shop extends StatelessWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.phone),
            Icon(Icons.message),
            Icon(Icons.contact_page),
          ],
        ),
      ),
    );
  }
}



// return MaterialApp(
//   home: Scaffold(
//
//     appBar: AppBar(
//       title: Text('앱임')
//     ),
//
//
//
//     body: Container(
//       padding: EdgeInsets.all(30),
//       margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
//       width: double.infinity,
//       height: 250,
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey),
//           top: BorderSide(color: Colors.grey),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
//             width: 200,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(13.0)),
//               image: DecorationImage(image: AssetImage('Logo.png')),
//             ),
//           ),
//           SizedBox(
//             width: 500,
//             height: double.infinity,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 60,
//                   child: Text('캐논 DSLR 100D (단렌즈, 충전기 16기가SD 포함)',
//                     style: TextStyle( fontSize: 20, fontWeight: FontWeight.w500 ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                   child: Text('성동구 행당동 . 끌올 10분 전',
//                   style: TextStyle( color: Colors.grey ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                   child: Text('210,000원',
//                   style: TextStyle( fontWeight: FontWeight.w600, fontSize: 20 ),
//                   ),
//                 ),
//                 SizedBox(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       SizedBox(
//                         child: Icon(Icons.heart_broken),
//                       ),
//                       SizedBox(
//                         child: Text('4', style: ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     ),
//
//
//     bottomNavigationBar: BottomAppBar(
//       child: SizedBox(
//         height: 70,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Icon(Icons.phone),
//             Icon(Icons.message),
//             Icon(Icons.contact_page),
//           ],
//         ),
//       ),
//     ),
//   )
// );
