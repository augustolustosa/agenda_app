import 'package:agenda_app/helpers/contact_helper.dart';
import 'package:agenda_app/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contatos = List();

  @override
  void initState(){
    super.initState();

    /*
    Contact c = Contact();
    c.name="jose";
    c.email="jose@aus.com";
    c.phone="2123123";
    helper.saveContact(c);
    */
    

    helper.getAllContacts().then((values){
      setState(() {
        contatos=values;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar A-Z"),
                value: OrderOptions.orderaz,
                ),

              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar Z-A"),
                value: OrderOptions.orderza,
                ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,),

      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contatos.length,
        itemBuilder: (context, index){
          return _contactCard(context, index);
        },
      ),
    );
  }


  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: contatos[index].img != null? 
                  FileImage(File(contatos[index].img)) : 
                    AssetImage("images/foto.png"),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contatos[index].name ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(contatos[index].email ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(contatos[index].phone ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
        
      },
      );
  }


  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return BottomSheet(
          onClosing: (){},
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text("Ligar", style: TextStyle(color: Colors.red, fontSize:  20.0),),
                      onPressed: (){
                        launch("tel:${contatos[index].phone}");
                        Navigator.pop(context);
                      }
                    ),
                    ),
                     
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text("Editar", style: TextStyle(color: Colors.red, fontSize:  20.0),),
                      onPressed: (){
                        Navigator.pop(context);
                        _showContactPage(contato: contatos[index]);
                      }),
                    ),
                    

                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Text("Excluir", style: TextStyle(color: Colors.red, fontSize:  20.0),),
                      onPressed: (){
                        helper.deleteContact(contatos[index].id);
                        setState(() {
                          contatos.removeAt(index);
                          Navigator.pop(context);
                        });
                      }
                    ),
                    ),
                ],
              ),
            );
          });
      }
      );
  }


  void _showContactPage({Contact contato}) async{
    final recContact = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ContactPage(contact: contato,)));
    if(recContact != null){
      if(contato != null){
        await helper.updateContacts(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      
      helper.getAllContacts().then((list){
          setState(() {
            contatos=list;
          });
        });
    }
  
  }

  void _orderList(OrderOptions result){
    switch (result) {
      case OrderOptions.orderaz:
        contatos.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contatos.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;        
      default:
    }
    setState(() {
      
    });
  }

}