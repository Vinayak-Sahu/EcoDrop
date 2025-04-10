import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Electronics';
  String _selectedCondition = 'Good';
  String _selectedNGO = 'Tech for Good';
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement donation logic
      print('Donating item: ${_titleController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate E-Waste'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Upload Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Images',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _images.length) {
                              return _buildAddImageButton();
                            }
                            return _buildImagePreview(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Item Details Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Item Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Electronics',
                            child: Text('Electronics'),
                          ),
                          DropdownMenuItem(
                            value: 'Computers',
                            child: Text('Computers'),
                          ),
                          DropdownMenuItem(
                            value: 'Mobile Devices',
                            child: Text('Mobile Devices'),
                          ),
                          DropdownMenuItem(
                            value: 'Accessories',
                            child: Text('Accessories'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCondition,
                        decoration: const InputDecoration(
                          labelText: 'Condition',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Excellent',
                            child: Text('Excellent'),
                          ),
                          DropdownMenuItem(
                            value: 'Good',
                            child: Text('Good'),
                          ),
                          DropdownMenuItem(
                            value: 'Fair',
                            child: Text('Fair'),
                          ),
                          DropdownMenuItem(
                            value: 'Poor',
                            child: Text('Poor'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCondition = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // NGO Selection Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select NGO',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedNGO,
                        decoration: const InputDecoration(
                          labelText: 'Choose NGO',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Tech for Good',
                            child: Text('Tech for Good'),
                          ),
                          DropdownMenuItem(
                            value: 'Digital Empowerment',
                            child: Text('Digital Empowerment'),
                          ),
                          DropdownMenuItem(
                            value: 'E-Waste Warriors',
                            child: Text('E-Waste Warriors'),
                          ),
                          DropdownMenuItem(
                            value: 'Green Tech Foundation',
                            child: Text('Green Tech Foundation'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedNGO = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'About the NGO:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getNGODescription(_selectedNGO),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Donate Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNGODescription(String ngo) {
    switch (ngo) {
      case 'Tech for Good':
        return 'Tech for Good focuses on providing technology education and resources to underprivileged communities.';
      case 'Digital Empowerment':
        return 'Digital Empowerment works to bridge the digital divide by providing access to technology and education.';
      case 'E-Waste Warriors':
        return 'E-Waste Warriors is dedicated to proper e-waste management and environmental conservation.';
      case 'Green Tech Foundation':
        return 'Green Tech Foundation promotes sustainable technology practices and environmental awareness.';
      default:
        return '';
    }
  }

  Widget _buildAddImageButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate, size: 40),
              SizedBox(height: 8),
              Text('Add Image'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(_images[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => _removeImage(index),
            ),
          ),
        ],
      ),
    );
  }
}
