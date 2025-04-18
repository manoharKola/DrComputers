import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final List<Map<String, String>> _dynamicFields = [];
  final List<File> _selectedImages = [];

  String serverUrl = "https://i38utvd5exkamac5ywqnda.on.drv.tw/www.drcomputers.com/upload"; // change to your actual server URL

  void _addDynamicField() {
    setState(() {
      _dynamicFields.add({"key": "", "value": ""});
    });
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
    if (result != null) {
      setState(() {
        _selectedImages.addAll(result.paths.map((path) => File(path!)));
      });
    }
  }

  Future<void> _saveProduct() async {
    final title = _titleController.text;
    final desc = _descController.text;
    final price = _priceController.text;

    if (title.isEmpty || desc.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }

    final Map<String, dynamic> productData = {
      "title": title,
      "description": desc,
      "price": price,
      "fields": {
        for (var item in _dynamicFields)
          item['key']!: item['value']!
      },
      "images": _selectedImages.map((img) => path.basename(img.path)).toList()
    };

    // Save JSON data to server
    final response = await http.post(
      Uri.parse(serverUrl + "/save_json"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(productData),
    );

    // Upload images
    for (var image in _selectedImages) {
      var request = http.MultipartRequest("POST", Uri.parse(serverUrl + "/upload_image"));
      request.files.add(await http.MultipartFile.fromPath("file", image.path));
      await request.send();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Product Title"),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text("Dynamic Fields:"),
            ..._dynamicFields.map((field) {
              final index = _dynamicFields.indexOf(field);
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => field['key'] = val,
                      decoration: const InputDecoration(labelText: "Field Name"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => field['value'] = val,
                      decoration: const InputDecoration(labelText: "Value"),
                    ),
                  ),
                ],
              );
            }).toList(),
            TextButton(
              onPressed: _addDynamicField,
              child: const Text("+ Add Field"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text("Pick Images"),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedImages.map((img) => Image.file(img, width: 100, height: 100)).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProduct,
              child: const Text("Save Product"),
            ),
          ],
        ),
      ),
    );
  }
}
