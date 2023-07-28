
import 'package:flutter/material.dart';
import 'package:Ghorbeh/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';
class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final Uri facebookUrl = Uri.parse('https://www.facebook.com/mh.gorbah') ;
  final  Uri instagramUrl =Uri.parse( 'https://www.instagram.com/ghorbah_bookshop') ;
  final whatsappNumber = '+962785967768';

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      drawer: drawer(),
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _launchURL(facebookUrl as String),
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Facebook',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _launchURL(instagramUrl as String),
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Instagram',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                final whatsappUrl = 'https://wa.me/$whatsappNumber';
                _launchURL(whatsappUrl);
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'WhatsApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
