/*import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:stage_app/methods.dart';
//import 'package:ssh2/ssh2.dart';

class PredictPage extends StatefulWidget {
  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final picker = ImagePicker();
  File? _image;
  final storage = FlutterSecureStorage();

  List<String> trees = [];

  String? selectedTreeName;

  @override
  void initState() {
    super.initState();
    fetchtrees();
  }

////////////////////////////////////////////
  String serverUrl = Path.globalpath +
      '/save-simage'; // Replace with your backend server's URL

  Future<void> uploadImageToServer(String path) async {
    try {
      final imageFile =
          File(path); // Replace with the path to your local image file
      //final imageBytes = await imageFile.readAsBytes();
      //final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'filename': '/hdd/marwen/Stage_Ete/image.png', 'data': imageFile}),
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully.');
      } else {
        print('Error uploading image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  /*Future<void> _uploadImage(String imagePath) async {
    // Convert the given image path to a File object for manipulation.
    final localFile = File(imagePath);

    final ssh = SSHClient(
      host: '10.8.0.26', // Replace with the IP address of the remote server.
      port:
          22, // Replace with the SSH port (use a different port if necessary).
      username:
          'marwen', // Replace with the appropriate username to connect to the server.
      passwordOrKey:
          'marwa2023', // Replace with the password or authentication key.
    );

    try {
      // ... Your existing code ...

      // Upload the localFile to the specified remote path using the sftpUpload() method.
      // Use a callback function to track the progress of the upload.
      await ssh.sftpUpload(
        path: localFile.path,
        toPath:
            "/hdd/marwen/Stage_Ete", // Replace with the desired remote path.
        callback: (progress) {
          print(progress + 'Ok');
        },
      );
    } on Exception catch (e) {
      print('Exception occurred: $e');
    } finally {
      await ssh.disconnectSFTP();
      ssh.disconnect();
    }
  }*/

  String? _predictionResult;
  Future<void> _sendImageForPrediction() async {
    if (_image == null) return;

    final url =
        'http://127.0.0.1:5000/predict'; // Replace with your Flask backend API URL
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(
      await http.MultipartFile.fromPath('image', _image!.path),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final predictionResponse = await response.stream.bytesToString();
        final predictionMap =
            json.decode(predictionResponse); // Convert JSON to map

        // Assuming your Flask backend returns the prediction under the key 'prediction'
        final prediction = predictionMap['result'];

        setState(() {
          _predictionResult = prediction;
        });
      } else {
        print(
            'Failed to send image for prediction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image for prediction: $e');
    }
  }

  void fetchtrees() async {
    try {
      var url = Path.globalpath +
          '/trees'; // Replace with your server URL or API endpoint

      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var treeList =
            data as List<dynamic>; // Update here to access the array directly

        var filteredtrees =
            treeList.map<String>((tree) => tree['name'].toString()).toList();

        setState(() {
          trees = filteredtrees;
          print(trees);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetch tree list.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An unexpected error occurred.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<String?> getUserEmail() async {
    return await storage.read(key: 'email');
  }

  void sendImageToServer(File image, String selectedTree, bool b) async {
    try {
      // Read the image file as bytes
      List<int> imageBytes = await image.readAsBytes();

      // Convert the image bytes to base64 string
      String base64Image = base64Encode(imageBytes);
      if (selectedItem == 'Select a tree') {
        _showSelectionDialog();
      }

      // Send the HTTP POST request to the server
      if (selectedItem != 'Select a tree') {
        final response = await http.post(
          Uri.parse(Path.globalpath + '/save-image'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'image': base64Image,
            'tree_name': selectedItem,
            'aiPredictedState': _predictionResult,
            'expertComment': '',
            'expertPredictedState': '',
            'ask_expert': b
          }),
        );

        var responseBody = jsonDecode(response.body);
        print(responseBody);
        print(response.statusCode);

        if (response.statusCode == 200) {
          print('Image sent successfully');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success!'),
                content: Text('Image sent successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          //run ai model
        } else {
          print('Failed to send image');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select a Tree',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: trees.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    trees[index],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    setState(() {
                      selectedItem = trees[index]; // Update the selected item
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the dialog without selecting any tree
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPredictionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding:
                EdgeInsets.all(24.0), // Increase the padding for more space
            constraints: BoxConstraints(
                maxWidth: 800, // Limit the maximum width of the dialog
                maxHeight: 800),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.eco_outlined,
                      color: Colors.green,
                      size: 40,
                    ),
                    Text(
                      "Leaf Status Prediction",
                      style: TextStyle(fontSize: 24, fontFamily: 'titre'),
                    ),
                    // Spacer
                  ],
                ),
                SizedBox(height: 8), // Small spacing
                Divider(
                  color: Colors.grey[400],
                  height: 1,
                ),
                SizedBox(height: 16), // Medium spacing
                Text(
                  '\nLeaf Status: $_predictionResult\n',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'ecriture',
                  ),
                ),
                SizedBox(height: 20), // Large spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        sendImageToServer(_image!, selectedItem, false);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Set button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        elevation: 2, // Add elevation for the highlight effect
                      ),
                      icon: Icon(Icons.check, size: 24),
                      label: Text(
                        "Accept\nPrediction",
                        style: TextStyle(fontSize: 16, fontFamily: 'ecriture'),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        sendImageToServer(_image!, selectedItem, true);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Set button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        elevation: 2, // Add elevation for the highlight effect
                      ),
                      icon: Icon(Icons.help, size: 24),
                      label: Text(
                        "Ask\nExpert",
                        style: TextStyle(fontSize: 16, fontFamily: 'ecriture'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

////////////////////////////////////////////
  void saveImageToServer1(String imageData) async {
    try {
      // Your server.js endpoint URL
      final url = Uri.parse(Path.globalpath + '/save1-simage');
      final Map<String, String> imageDataMap = {'imageData': imageData};
      final jsonData = jsonEncode(imageDataMap);
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: jsonData);
      if (response.statusCode == 200) {
        print('Image saved successfully on the server.');
      } else {
        print('Failed to save the image on the server.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

////////////////////////////////////////////
  Future<void> _uploadImageToServer() async {
    if (_image == null) return;

    try {
      final imageFile = File(_image!.path);

      // Read the image file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // Convert the image bytes to base64 string
      String base64Image = base64Encode(imageBytes);

      // Send the HTTP POST request to the server
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'filename':
              '/hdd/marwen/Stage_Ete/', // Replace with your desired file path on the server
          'data': base64Image,
        }),
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully.');
        // Handle the response from the server if needed
      } else {
        print('Error uploading image. Status code: ${response.statusCode}');
        // Handle the error if needed
      }
    } catch (e) {
      print('Error: $e');
      // Handle any other errors that occur during the process
    }
  }

  void uploadFileToSFTP(String localFile, String remotePath) async {
    final url = Path.globalpath + '/upload';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'localFile': localFile, 'remotePath': remotePath}),
      );

      if (response.statusCode == 200) {
        print('File uploaded successfully!');
      } else {
        print('File upload failed: ${response.body}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  String selectedItem = 'Select a tree';

  @override
  Widget build(BuildContext context) {
    //s = "Predict Page";
    return SingleChildScrollView(
      padding: EdgeInsets.all(100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //SizedBox(height: 16),
          Text(
            'Take a Picture',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'ecriture',
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Capture or select an image to predict',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontFamily: 'ecriture',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                      25.0), // Adjust the value as per your preference
                  child: Image.file(
                    File(_image!.path),
                    height: 150,
                    fit: BoxFit
                        .cover, // Adjust the fit based on your requirements
                  ),
                )
              : Container(),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: getImageFromCamera,
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt, size: 24),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Take Picture',
                  style: TextStyle(
                    fontSize: 21,
                    fontFamily: 'ecriture',
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: getImageFromGallery,
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library, size: 28),
                SizedBox(width: 16),
                Text(
                  'Select Picture',
                  style: TextStyle(
                    fontSize: 21,
                    fontFamily: 'ecriture',
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: _showSelectionDialog,
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.forest_rounded),
                SizedBox(width: 5),
                Text(
                  selectedItem,
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'ecriture',
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
          SizedBox(height: 10),

          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async => {
              //await _sendImageForPrediction(),
              //_showPredictionDialog(context),
              //_uploadImage(_image!.path),
              uploadFileToSFTP(_image!.path, '/hdd/marwen/Stage_Ete/'),
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              primary: Colors.green,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10),
                Text(
                  "Predict",
                  style: TextStyle(
                    fontSize: 21,
                    fontFamily: 'ecriture',
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}*/
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:stage_app/methods.dart';
//import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/services.dart';
//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';

import 'farmertree.dart';

class PredictPage extends StatefulWidget {
  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final picker = ImagePicker();
  File? _image;
  final storage = FlutterSecureStorage();

  List<String> trees = [];

  String? selectedTreeName;

  @override
  void initState() {
    super.initState();
    loadModel();
    fetchtrees();
  }

  late ModelObjectDetection _objectModel;

  Future loadModel() async {
    //String pathImageModel = "assets/models/model_classification.pt";
    //String pathCustomModel = "assets/models/custom_model.ptl";
    String pathObjectDetectionModel = "assets/models/best.torchscript";
    try {
      /*_imageModel = await FlutterPytorch.loadClassificationModel(
          pathImageModel, 224, 224,
          labelPath: "assets/labels/label_classification_imageNet.txt");*/
      //_customModel = await PytorchLite.loadCustomModel(pathCustomModel);
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          pathObjectDetectionModel, 3, 640, 640,
          labelPath: "assets/labels/labels.txt");
      print(1);
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  List<ResultObjectDetection?> objDetect = [];

  Future runObjectDetection(File image) async {
    //pick a random image
    //final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print("---------------------------------");
    objDetect = await _objectModel.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        IOUThershold: 0.3);
    print("---------------------------------");
    objDetect.forEach((element) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    });
    objDetect.sort((a, b) => b!.score.compareTo(a!.score));
    print(objDetect[0]);
    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
      _predictionResult = objDetect[0]?.className;
    });
  }

  List<Widget> boxes = [];
  List<Widget> buildBoundingBoxes() {
    if (_image == null || objDetect.isEmpty) return [];

    double scaleX = 200;
    double scaleY = 150;

    for (var detection in objDetect) {
      final rect = detection!.rect;
      final left = rect.left * scaleX;
      final top = rect.top * scaleY;
      final right = rect.right * scaleX;
      final bottom = rect.bottom * scaleY;
      final width = right - left;
      final height = bottom - top;

      boxes.add(
        Center(
          child: Text(
            "${detection.className} (${detection.score.toStringAsFixed(2)})",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      );

      boxes.add(Positioned(
        left: left,
        top: top,
        width: width,
        height: height,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
              ),
            ),
          ],
        ),
      ));

      ;
    }

    return boxes;
  }

  String? _predictionResult;
  Future<void> _sendImageForPrediction() async {
    if (_image == null) return;

    final url =
        'http://localhost:5000/predict'; // Replace with your Flask backend API URL
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(
      await http.MultipartFile.fromPath('image', _image!.path),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final predictionResponse = await response.stream.bytesToString();
        final predictionMap =
            json.decode(predictionResponse); // Convert JSON to map
        print(predictionMap);

        // Assuming your Flask backend returns the prediction under the key 'prediction'
        final prediction = predictionMap['result'];

        setState(() {
          _predictionResult = prediction;
        });
      } else {
        print(
            'Failed to send image for prediction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image for prediction: $e');
    }
  }

  void fetchtrees() async {
    try {
      var url = Path.globalpath +
          '/trees'; // Replace with your server URL or API endpoint

      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var treeList =
            data as List<dynamic>; // Update here to access the array directly

        var filteredtrees =
            treeList.map<String>((tree) => tree['name'].toString()).toList();

        setState(() {
          trees = filteredtrees;
          print(trees);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to fetch trees',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
      /*showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An unexpected error occurred.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );*/
    }
  }

  int levenshteinDistance(String s1, String s2) {
    var m = s1.length;
    var n = s2.length;

    var dp = List.generate(m + 1, (i) => List<int>.filled(n + 1, 0));

    for (var i = 0; i <= m; i++) {
      for (var j = 0; j <= n; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((min, e) => e < min ? e : min);
        }
      }
    }

    return dp[m][n];
  }

  bool isHealthy(String input) {
    final target = "Healthy";
    final distance = levenshteinDistance(input, target);
    // You can adjust this threshold value based on your desired similarity level
    final threshold = 3;

    return distance <= threshold;
  }

  Future<void> fetchPictures(String selectedTreeName) async {
    try {
      final response = await http.get(
        Uri.parse('${Path.globalpath}/pictures/${selectedTreeName}'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var imagesList = data as List<dynamic>;
        bool b = false;
        for (int i = 0; i < imagesList.length; i++) {
          if (!isHealthy(imagesList[i]['aiPredictedState']) &&
              imagesList[i]['expertPredictedState'] == '') {
            treeStatusMap[selectedTreeName] = "Sick";
            b = true;
            break;
          }
          if (imagesList[i]['expertPredictedState'] != '' &&
              !isHealthy(imagesList[i]['expertPredictedState'])) {
            treeStatusMap[selectedTreeName] = "Sick";
            b = true;
            break;
          }
        }
        if (b == false) {
          treeStatusMap[selectedTreeName] = 'Healthy';
        }
        print(treeStatusMap);
      } else {
        print('Failed to fetch pictures');
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Error',
              contentText: 'Failed to fetch leaves',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Map<String, String> _deserializeMap(String mapString) {
    final keyValuePairs = mapString
        .substring(1, mapString.length - 1) // Remove curly braces
        .split(', ')
        .map((entry) => entry.split(': '))
        .toList();

    final Map<String, String> resultMap = {};
    for (final pair in keyValuePairs) {
      resultMap[pair[0]] = pair[1];
    }

    return resultMap;
  }

  Future<void> fetchTrees() async {
    try {
      final storedMapAsString = await storage.read(key: 'treeStatusMap');
      if (storedMapAsString != null) {
        treeStatusMap = _deserializeMap(storedMapAsString);
      }

      await fetchPictures(selectedItem);
      print("11");

      storage.write(key: 'treeStatusMap', value: treeStatusMap.toString());
      storage.write(key: 'length', value: treeStatusMap.length.toString());

      setState(() {
        storage.write(key: 'treeStatusMap', value: treeStatusMap.toString());
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<File> compressImage(File file) async {
    // Compress the image using the flutter_image_compress package
    final compressedImage = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1080,
      minHeight: 1920,
      quality: 75,
    );

    // Write the compressed image data to a new file
    final compressedFile = File(file.path + '_compressed.jpg');
    await compressedFile.writeAsBytes(compressedImage!);

    // Check if the compressed file size is less than 2 MB
    if (await compressedFile.length() < 0.5 * 1024 * 1024) {
      return compressedFile;
    } else {
      // If the compressed file size is still greater than 2 MB, recursively call the function to compress it further
      return compressImage(compressedFile);
    }
  }

  Future<void> sendImageToServer(
      File image, String selectedTree, bool b) async {
    try {
      // Read the image file as bytes
      List<int> imageBytes = await image.readAsBytes();

      // Convert the image bytes to base64 string
      String base64Image = base64Encode(imageBytes);
      if (selectedItem == 'Select a tree') {
        _showSelectionDialog();
      }

      // Send the HTTP POST request to the server
      if (selectedItem != 'Select a tree') {
        final response = await http.post(
          Uri.parse(Path.globalpath + '/save-image'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'image': base64Image,
            'tree_name': selectedItem,
            'aiPredictedState': _predictionResult,
            'expertComment': '',
            'expertPredictedState': '',
            'ask_expert': b
          }),
        );

        var responseBody = jsonDecode(response.body);
        print(responseBody);
        print(response.statusCode);

        if (response.statusCode == 200) {
          print('Image sent successfully');

          //run ai model
        } else {
          print('Failed to send image');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    List<ResultObjectDetection?> newDetectionList = [];
    setState(() {
      objDetect = newDetectionList;
      boxes.clear();
    });
    if (pickedFile != null) {
      File _image1 = await compressImage(File(pickedFile.path)) as File;
      setState(() {
        _image = _image1;
      });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    List<ResultObjectDetection?> newDetectionList = [];
    setState(() {
      objDetect = newDetectionList;
      boxes.clear();
    });
    if (pickedFile != null) {
      File _image1 = await compressImage(File(pickedFile.path)) as File;
      setState(() {
        _image = _image1;
      });
    }
  }

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select a Tree',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "titre"),
          ),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: trees.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    trees[index],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        fontFamily: "ecriture"),
                  ),
                  onTap: () {
                    setState(() {
                      selectedItem = trees[index]; // Update the selected item
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the dialog without selecting any tree
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ecriture',
                    color: AppColors.vertnormal),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPredictionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding:
                EdgeInsets.all(24.0), // Increase the padding for more space
            constraints: BoxConstraints(
                maxWidth: 800, // Limit the maximum width of the dialog
                maxHeight: 800),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.eco_outlined,
                      color: Color(0xFF349E74),
                      size: 40,
                    ),
                    Text(
                      "Leaf Status Prediction",
                      style: TextStyle(fontSize: 24, fontFamily: 'titre'),
                    ),
                    // Spacer
                  ],
                ),
                SizedBox(height: 8), // Small spacing
                Divider(
                  color: Colors.grey[400],
                  height: 1,
                ),
                SizedBox(height: 16), // Medium spacing
                Text(
                  '\nLeaf Status: $_predictionResult\n',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'ecriture',
                  ),
                ),
                SizedBox(height: 20), // Large spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Perform action when "Accept Prediction" button is pressed
                        // For example, you can close the dialog here
                        await sendImageToServer(_image!, selectedItem, false);
                        await fetchTrees();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF349E74), // Set button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        elevation: 2, // Add elevation for the highlight effect
                      ),
                      icon: Icon(Icons.check, size: 24),
                      label: Text(
                        "Accept\nPrediction",
                        style: TextStyle(fontSize: 16, fontFamily: 'ecriture'),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Perform action when "Ask Expert" button is pressed
                        // For example, you can navigate to another screen to ask an expert
                        // Here, I'm just closing the dialog for demonstration purposes
                        if (selectedItem != "Select a tree") {
                          await sendImageToServer(_image!, selectedItem, true);
                          await fetchTrees();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: 'Success',
                                contentText:
                                    'Task sent successfully to experts',
                                onOkPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9F4A54), // Set button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        elevation: 2, // Add elevation for the highlight effect
                      ),
                      icon: Icon(
                        Icons.help,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: Text(
                        "\t\t\tAsk\n\t\t\tExpert\t\t\t\t",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'ecriture',
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String selectedItem = 'Select a tree';

  @override
  Widget build(BuildContext context) {
    //s = "Predict Page";
    return SingleChildScrollView(
      padding: EdgeInsets.all(100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //SizedBox(height: 16),
          Text(
            'Take a Picture',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'ecriture',
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Capture or select an image to predict',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontFamily: 'ecriture',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              /*Size //imageSize =
                  Size(constraints.maxWidth, constraints.maxHeight);*/
              return Stack(
                children: [
                  if (_image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.file(
                        File(_image!.path),
                        height: 150,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ...buildBoundingBoxes(),
                ],
              );
            },
          ),

          SizedBox(height: 16),
          ElevatedButton(
            onPressed: getImageFromCamera,
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Color(0xFFEAF4F5)),
              primary: Color(0xFFEAF4F5),
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt, size: 24),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Take Picture',
                  style: TextStyle(
                    fontSize: 21,
                    fontFamily: 'ecriture',
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: getImageFromGallery,
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Color(0xFFEAF4F5)),
              primary: Color(0xFFEAF4F5),
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library, size: 28),
                SizedBox(width: 16),
                Text(
                  'Select Picture',
                  style: TextStyle(
                    fontSize: 21,
                    fontFamily: 'ecriture',
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: _showSelectionDialog,
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              padding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.forest_rounded),
                SizedBox(width: 5),
                Text(
                  selectedItem,
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'ecriture',
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
          SizedBox(height: 10),

          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async => {
              await //_sendImageForPrediction(),
              runObjectDetection(_image!),
              _showPredictionDialog(context),
            }, //sendImageToServer(_image!, selectedItem),
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Color(0xFFEAF4F5)),
              primary: Color(0xFFEAF4F5),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.all(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10),
                Text(
                  "Predict",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontFamily: 'ecriture',
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
