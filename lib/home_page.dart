import 'package:flutter/material.dart';
import 'package:firebase_login_flutter/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Registro y Control de Acceso a la app de avisos TecNM Roque
// Alejandro Guzmán Zazueta                  15/11/2017
class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }
    }

    return new Scaffold(
        appBar: new AppBar(
          title: Text("TecNM Roque Avisos"),
          actions: <Widget>[
            new FlatButton(
                onPressed: _signOut,
                child: new Text('Cerrar Sesión', style: new TextStyle(fontSize: 17.0, color: Colors.white))
            )
          ],
        ),
        body: ListPage()
    );
  }
}
// List View con los avisos del TecNM Roque
class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

    Future _data;

  Future getPost() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Avisos").getDocuments();
    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot post)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(post: post,)));
  }

  @override
  void initState() {
    super.initState();
    _data = getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _data,
          builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Text("Cargando..."),
          );
        } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index){

                  return Card(
                    margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(snapshot.data[index].data["Titulo"], style: TextStyle(fontSize: 20.0),),
                      onTap: () => navigateToDetail(snapshot.data[index]),
                    ),
                  );
                });
        } // fin del else

      }),
    );
  }
}
// Detalle de aviso mostrando imagen del storage
class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.data["Titulo"]),
      ),
      body: Container(
        child: Card(
          child: ListTile(
            title: Image.network("https://firebasestorage.googleapis.com/v0/b/fir-login-19d40.appspot.com/o/"+widget.post.data["Imagen"]),      //Text(widget.post.data["Titulo"]),
            subtitle: Text(widget.post.data["Descripcion"], style: TextStyle(fontSize: 20.0),),
          ),
        ),
      ),
    );
  }
}

