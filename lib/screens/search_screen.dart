import 'package:chatapp/Modals/modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatscreen.dart';

class SearchScreen extends StatefulWidget {
    final UserModel user;
    const SearchScreen({Key? key, required this.user, }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch()async{
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection('users').where("name",isEqualTo: searchController.text).get().then((value){
      if(value.docs.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No User Found")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      for (var user in value.docs) {
        if(user.data()['email'] != widget.user.email){
          searchResult.add(user.data());
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Search..."),
          ),
          body:Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "type username..."
                        ),
                      ),
                    ),
                  ),
              IconButton(onPressed: (){
                onSearch();
              }, icon: Icon(Icons.search))]),

            if(searchResult.length > 0)
        Expanded(child: ListView.builder(
            itemCount: searchResult.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return ListTile(
                leading: CircleAvatar(
                  child: Image.network(searchResult[index]['image']),
                ),
                title: Text(searchResult[index]['name']),
                subtitle: Text(searchResult[index]['email']),
                trailing: IconButton(onPressed: (){
                  setState(() {
                    searchController.text = "";
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
                      currentUser: widget.user,
                      friendId: searchResult[index]['uid'],
                      friendName: searchResult[index]['name'],
                      friendImage: searchResult[index]['image'])));
                }, icon: Icon(Icons.message)),
              );
            }))
        else if(isLoading == true)
        Center(child: CircularProgressIndicator(),)
        ],


    )
        );
      }
    );


  }
}
