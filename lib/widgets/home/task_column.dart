import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskColumn extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final String url;
  final String jenis;
  final Widget widget;
  TaskColumn(
      {required this.icon,
      required this.iconBackgroundColor,
      required this.title,
      required this.subtitle,
      required this.jenis,
      required this.url,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundColor: iconBackgroundColor,
            child: Icon(
              icon,
              size: 15.0,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new GestureDetector(
                child: new Text(title),
              ),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        if (jenis == 'url') {
          _launchUrl(Uri.parse(url));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget,
            ),
          );
        }
      },
    );
  }
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}
