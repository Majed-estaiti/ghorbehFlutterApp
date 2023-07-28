import 'package:flutter/material.dart';
import 'package:Ghorbeh/mainScreens/bookList.dart';

class categoryList extends StatelessWidget {
  final List<Map<String, dynamic>> cardList = [
    {
      'title': 'English Books',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ghorbehflutter-a4a45.appspot.com/o/category%2F%D8%AA%D9%86%D8%B2%D9%8A%D9%84%20(1).png?alt=media&token=eda01f9e-5f58-4170-b3ea-4b3c957671b9',
    },
    {
      'title': 'Romantic Books',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ghorbehflutter-a4a45.appspot.com/o/category%2Fromantic.png?alt=media&token=9fa4a5ae-fb2b-4b1a-934e-048ba7dc63a6',
    },
    {
      'title': 'Historical Books',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ghorbehflutter-a4a45.appspot.com/o/category%2Fhis.png?alt=media&token=f6ab9c54-9231-4629-81a9-f57fbfe2931d',
    },
    {
      'title': 'Human Development Books',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ghorbehflutter-a4a45.appspot.com/o/category%2F%D8%AA%D9%86%D8%B2%D9%8A%D9%84%20(1).png?alt=media&token=c07e0a35-5805-4e55-981d-ccea13bbdf2b',
    },
    {
      'title': 'Religious Books',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ghorbehflutter-a4a45.appspot.com/o/category%2Freg.png?alt=media&token=f3a956f1-14a7-4954-8d17-2e21e527ef70',
    },
    {
      'title': 'Horror and Fantasy Books',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ghorbehflutter-a4a45.appspot.com/o/category%2Fhorror.png?alt=media&token=4bc028a8-a9fc-4cce-90ef-265c581d5054',
    },
    {
      'title': 'Philosophy Books',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ghorbehflutter-a4a45.appspot.com/o/category%2Fph.png?alt=media&token=952b08e7-c689-4d19-ad42-2cb6831bf113',
    },
    {
      'title': 'Others Books',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/ghorbehflutter-a4a45.appspot.com/o/category%2F%D8%AA%D9%86%D8%B2%D9%8A%D9%84.png?alt=media&token=be62708c-fe26-4392-bc3b-92633f2d1209',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: cardList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => bookList(cat: cardList[index]["title"]),
                ),
              );
            },
            child: SizedBox(
              height: 50,
              child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.grey,
                  margin: EdgeInsets.all(10),
                  elevation: 0,
                  child: Center(
                    child:
                        Row(children: [
                          SizedBox(width: 10,),
                          Text(cardList[index]['title']),
                          SizedBox(width: 10,),


                        ],)

                  )),
            ));
      },
    );
  }
}
