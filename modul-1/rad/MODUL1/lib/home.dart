import 'package:flutter/material.dart';
import 'package:praktikum1/detail.dart';

class HomePage extends StatelessWidget {
  final List<String> hotels = List.generate(5, (_) => 'National Park Yosemite');

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        title: Text(
          'Hi, User',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/pp.png'), 
          ),
          SizedBox(width: 10), 
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), 
        child: ListView(
          children: [
            SectionTitle(title: 'Hot Places'),
            SizedBox(height: 8), 
            SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(title: hotels[index]),
                        ),);},
                    child: HotPlaceCard(),
                  ),);},),),
            SizedBox(height: 18), 
            SectionTitle(title: 'Best Hotels'), 
            SizedBox(height: 8),
            ListView.builder(
              physics:
                  NeverScrollableScrollPhysics(), 
              shrinkWrap: true,
              itemCount: hotels.length, 
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(title: hotels[index]),
                        ),);},
                    child: HotelCard(), 
                  ),);},),
                  ],),),);}}

class SectionTitle extends StatelessWidget {
  final String title; 

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('See All', style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],);}}

class HotPlaceCard extends StatelessWidget {
  const HotPlaceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/home.png',
              height: 54,
              width: 54,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'National Park Yosemite',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Colors.grey,
                  ),
                  Text(
                    'California',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),],),],),],),);}}

class HotelCard extends StatelessWidget {
  const HotelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), 
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/home.png',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  'National Park Yosemite',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quis, doloribus. Eos, accusantium doloremque! Tenetur, sed.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 4,
                  overflow:
                      TextOverflow
                          .ellipsis,
                ),],),),],),);}}
