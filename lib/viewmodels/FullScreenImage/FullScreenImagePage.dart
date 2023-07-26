import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:convert';
import 'package:palette_generator/palette_generator.dart';

import 'package:widgets_to_image/widgets_to_image.dart';
import 'dart:ui' as ui;

import '../../models/api_edit.dart';

class FullScreenImagePage extends StatefulWidget {
  final String imageUrl;

  FullScreenImagePage({required this.imageUrl});

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  List<Res> resList = [];

  List<TemplateModel> templateList = [];

  List<Res> resList2 = [];
  Color imageColor = Colors.brown;

  WidgetsToImageController controller = WidgetsToImageController();
  // to save image bytes of widget
  Uint8List? bytes;

  String? phone;
  String? website;
  String? address;
  String? email;
  bool defaultcolor = false;
  Color bgColor = Colors.white;
  Future<Color> getImageColor(String imageUrl) async {
    final image = NetworkImage(imageUrl);
    final paletteGenerator = await PaletteGenerator.fromImageProvider(image);
    return paletteGenerator.dominantColor!.color;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchData();
      detailData();
      final firstImageUrl = resList.isNotEmpty ? resList[0].img : null;

      if (firstImageUrl != null) {
        getImageColor(firstImageUrl).then((color) {
          setState(() {
            imageColor = color;
          });
        }).catchError((error) {
          // Handle the error if needed.
          print(error);
        });
      } else {
        // Handle the case when the first image URL is null.
        print("First image URL is null.");
      }
    });
  }

  //image api data
  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://yetlosocial.yetloapps.com/api-1.0.3/customer_select_frameslist');
    final headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NTUyNzI4NzMsImlzcyI6IllqRzhMdjE5TDBVclRSZmFXc3NoT0k2aXJrTGpzMWtSIiwic3ViIjoiTXV2aWVyZWNrIEF1dGhlbnRpY2F0aW9uIn0.XMiCPoVEJa0WJiDy3NuFkTXUdFyxEonEvVpkDONMr4s',
    };
    final body = {
      'customer_id': '70',
      'token': '27f2ac-7423b6-403f6d-44aec7-0c319c',
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['res'] != null) {
        setState(() {
          resList = List<Res>.from(data['res'].map((res) => Res.fromJson(res)));
        });
      }
    } else {
      // Handle error or show error message
    }
    templateList = [
      TemplateModel(
          resList[0].img ?? '',
          PositionStack(290, 0, 10, 0),
          PositionStack(290, 0, 190, 0),
          PositionStack(360, 0, 10, 0),
          PositionStack(370, 10, 210, 0)),
      TemplateModel(
          resList[1].img ?? '',
          PositionStack(290, 0, 110, 0),
          PositionStack(290, 0, 210, 0),
          PositionStack(360, 0, 90, 0),
          PositionStack(370, 10, 280, 0)),
      TemplateModel(
          resList[2].img ?? '',
          PositionStack(290, 0, 50, 0),
          PositionStack(290, 0, 180, 0),
          PositionStack(360, 0, 90, 0),
          PositionStack(370, 10, 280, 0)),
      TemplateModel(
          resList[3].img ?? '',
          PositionStack(300, 0, 50, 0),
          PositionStack(300, 0, 180, 0),
          PositionStack(360, 0, 20, 0),
          PositionStack(370, 10, 280, 0)),
      TemplateModel(
          resList[4].img ?? '',
          PositionStack(300, 0, 50, 0),
          PositionStack(-330, 0, 210, 0),
          PositionStack(360, 0, 20, 0),
          PositionStack(370, 10, 280, 0)),
      TemplateModel(
          resList[5].img ?? '',
          PositionStack(300, 0, 20, 0),
          PositionStack(-330, 0, 210, 0),
          PositionStack(360, 0, 20, 0),
          PositionStack(370, 10, 280, 0)),
      TemplateModel(
          resList[6].img ?? '',
          PositionStack(360, 0, 20, 0),
          PositionStack(300, 0, 20, 0),
          PositionStack(-360, 0, 100, 0),
          PositionStack(370, 10, 280, 0)),
      TemplateModel(
          resList[8].img ?? '',
          PositionStack(300, 0, 250, 0),
          PositionStack(300, 0, 20, 0),
          PositionStack(360, 0, 20, 0),
          PositionStack(370, 10, 280, 0)),
      TemplateModel(
          resList[10].img ?? '',
          PositionStack(330, 0, 290, 0),
          PositionStack(330, 0, 20, 0),
          PositionStack(360, 0, 20, 0),
          PositionStack(370, 10, 280, 0)),
      TemplateModel(
          resList[12].img ?? '',
          PositionStack(-360, 0, 290, 0),
          PositionStack(320, 0, 190, 0),
          PositionStack(360, 0, 190, 0),
          PositionStack(-310, 10, 280, 0)),
    ];
  }

  String extractEndData(String? fullData) {
    if (fullData == null) return 'N/A';
    final dataList = fullData.split(',');
    return dataList.isNotEmpty ? dataList.last : 'N/A';
  }

  // text data
  Future<void> detailData() async {
    final url = 'https://yetlosocial.yetloapps.com/api-1.0.3/getprofile';
    final headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NTUyNzI4NzMsImlzcyI6IllqRzhMdjE5TDBVclRSZmFXc3NoT0k2aXJrTGpzMWtSIiwic3ViIjoiTXV2aWVyZWNrIEF1dGhlbnRpY2F0aW9uIn0.XMiCPoVEJa0WJiDy3NuFkTXUdFyxEonEvVpkDONMr4s',
    };

    final body = {
      'customer_id': '70',
      'token': '27f2ac-7423b6-403f6d-44aec7-0c319c',
    };

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // Request successful, parse the JSON response
      final jsonData = json.decode(response.body);
      // Update the UI with the received data
      setState(() {
        phone = jsonData['res'][0]['phone'];
        website = jsonData['res'][0]['website'];
        address = jsonData['res'][0]['address'];
        email = jsonData['res'][0]['email'];
      });
    } else {
      // Request failed, handle the error
      print('Request failed with status: ${response.statusCode}');
    }
  }

  GlobalKey _cardKey = GlobalKey();

  Future<void> _captureAndSaveImage(String imageUrl) async {
    try {
      RenderRepaintBoundary boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      final firstImageUrl = resList.isNotEmpty ? resList[0].img : null;
      if (firstImageUrl != null) {
      } else {
        print("First image URL is null.");
      }

      final result = await ImageGallerySaver.saveImage(pngBytes!);

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Image and text content downloaded successfully!'),
          duration: Duration(seconds: 2),
        ));
        print('Image saved to gallery!');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save image: ${result['errorMessage']}'),
          duration: Duration(seconds: 2),
        ));

        print('Failed to save image: ${result['errorMessage']}');
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving image: $e'),
        duration: Duration(seconds: 2),
      ));
      print('Error capturing and saving image: $e\n$stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Edit now'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          final bytes = await controller.capture();
          setState(() {
            this.bytes = bytes;
            _captureAndSaveImage(widget.imageUrl);
            // downloadImage(widget.imageUrl);
          });
        },
        child: Icon(Icons.download),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            if (bytes != null) buildImage(bytes!),
            WidgetsToImage(child: Cardimg(), controller: controller),
            Positioned(
                bottom: 40,
                child: DefaultTabController(
                  length: 2,
                  child: Container(
                    width: 400,
                    height: kToolbarHeight + 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          child: TabBar(
                            padding: EdgeInsets.only(left: 20),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.red),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Text('Background color'),
                              Text('Template color'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: TabBarView(children: [
                            SingleChildScrollView(
                              child: FastColorPicker(
                                selectedColor: bgColor,
                                onColorSelected: (color) {
                                  setState(() {
                                    bgColor = color;
                                  });
                                },
                              ),
                            ),
                            SingleChildScrollView(
                              child: FastColorPicker(
                                selectedColor: imageColor,
                                onColorSelected: (color) {
                                  setState(() {
                                    defaultcolor = true;
                                    imageColor = color;
                                  });
                                },
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  //page view widget
  Widget Cardimg() {
    return RepaintBoundary(
      key: _cardKey,
      child: Card(
        child: SizedBox(
          child: Stack(
            children: [
              Container(
                  color: bgColor,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(widget.imageUrl)),
              SizedBox(
                height: 400,
                width: 500,
                child: PageView.builder(
                  itemCount: templateList.length,
                  itemBuilder: (context, index) {
                    final res = resList[index];

                    return Stack(
                      children: [
                        Image.network(
                          templateList[index].image,
                          fit: BoxFit.cover,
                          width: 500,
                          color: defaultcolor ? imageColor : null,
                        ),
                        Positioned(
                          top: templateList[index].phone.top,
                          bottom: templateList[index].phone.bottom,
                          left: templateList[index].phone.left,
                          right: templateList[index].phone.right,
                          child: Row(
                            children: [
                              ImageIcon(
                                NetworkImage(res.mobile ?? ''),
                                color: Colors.white,
                                size: 15,
                              ),
                              Text(
                                phone ?? '',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: templateList[index].mail.top,
                          bottom: templateList[index].mail.bottom,
                          left: templateList[index].mail.left,
                          right: templateList[index].mail.right,
                          child: Row(
                            children: [
                              ImageIcon(NetworkImage(res.email ?? ''),
                                  color: Colors.white, size: 15),
                              Text(
                                email ?? '',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: templateList[index].website.top,
                          bottom: templateList[index].website.bottom,
                          left: templateList[index].website.left,
                          right: templateList[index].website.right,
                          child: Row(
                            children: [
                              ImageIcon(
                                NetworkImage(res.website ?? ''),
                                color: Colors.white,
                                size: 15,
                              ),
                              Text(
                                website ?? '',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: templateList[index].location.top,
                          bottom: templateList[index].location.bottom,
                          left: templateList[index].location.left,
                          right: templateList[index].location.right,
                          child: Row(
                            children: [
                              ImageIcon(NetworkImage(res.location ?? ''),
                                  color: Colors.white, size: 15),
                              Text(
                                extractEndData(address) ?? '',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                  left: -50,
                  top: -10,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image(
                      image: NetworkImage(widget.imageUrl),
                      color: null,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(Uint8List bytes) => Image.memory(bytes);
}

//position model
class PositionStack {
  final double top;
  final double bottom;
  final double left;
  final double right;

  PositionStack(this.top, this.bottom, this.left, this.right);
}

// image and text data
class TemplateModel {
  final String image;
  final PositionStack phone;
  final PositionStack mail;
  final PositionStack website;
  final PositionStack location;

  TemplateModel(this.image, this.phone, this.mail, this.website, this.location);
}
