import 'package:flutter/material.dart';
import 'package:flutter_test_app/data/repositories/api_interface.dart';
import 'package:flutter_test_app/domain/models/card.dart';
// import 'package:flutter_test_app/domain/models/home.dart';

class MockRepository extends ApiInterface {
  @override
  Future<List<CardData>?> loadData() async {
    return [
        CardData(
          'Ноутбук',
          descriptionText: '4ядря 4 гига',
          icon: Icons.waving_hand_sharp,
          imageUrl: 'https://w7.pngwing.com/pngs/790/725/png-transparent-laptop-lenovo-ideapad-yoga-13-lenovo-yoga-720-13-lenovo-yoga-720-15-laptop-electronics-netbook-computer-thumbnail.png',
        ),
        CardData(
          'Смартфон',
          descriptionText: 'Самсунг?',
          icon: Icons.local_activity,
          imageUrl: 'https://static.vecteezy.com/system/resources/previews/022/722/945/non_2x/samsung-galaxy-s23-ultra-transparent-image-free-png.png',
        ),
        CardData(
          'Процессор',
          descriptionText: '5 5600x',
          icon: Icons.face,
          imageUrl: 'https://cdn.citilink.ru/GHh35ODAI5AMlUID0GD2DxFYzUgOqtYqaJS1Lif_TXI/resizing_type:fit/gravity:sm/width:1200/height:750/plain/product-images/bd7752f0-19a1-471d-ac80-de15d55ab131.jpg',
        ),
      ];
  }
}
