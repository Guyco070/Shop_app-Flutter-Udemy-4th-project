// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static String routeName = '/edit-product-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocusNode = FocusNode(); // work without that
  // final _descriptionFocusNode = FocusNode(); // work without that
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  bool _isInit = true;
  // Map<String, String> _initValues = {
  //   'title': '',
  //   'description': '',
  //   'price': '',
  //   'imageUrl': '',
  // };
  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId =
          ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId as String);
        // _initValues = {
        //   'title': _editProduct.title,
        //   'description': _editProduct.description,
        //   'price': _editProduct.price.toString(),
        //   'imageUrl': '',
        // };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    // _priceFocusNode.dispose();
    // _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) return;
      setState(() {});
    }
  }

  void _saveForm() {
    final bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    Products products = Provider.of<Products>(context, listen: false);
    if (_editProduct.id.isNotEmpty) {
      products.updateProduct(_editProduct.id, _editProduct);
    } else
      products.addProduct(_editProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  initialValue: _editProduct.title,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) => _editProduct =
                      Product.createUpdatedProduct(
                          'title', value as String, _editProduct),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please provide a title.';
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  initialValue: _editProduct.price.toString(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  // focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    // FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) => _editProduct =
                      Product.createUpdatedProduct(
                          'price', double.parse(value as String), _editProduct),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter a price.';
                    if (double.tryParse(value) == null)
                      return 'Please enter a valid number.';
                    if (double.parse(value) <= 0)
                      return 'Please enter a number grater then zero.';
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  initialValue: _editProduct.description,
                  keyboardType: TextInputType.multiline, // add Enter key
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  // focusNode: _descriptionFocusNode,
                  onSaved: (value) => _editProduct =
                      Product.createUpdatedProduct(
                          'description', value as String, _editProduct),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please provide a description.';
                    if (value.length < 10)
                      return 'Should be at least 10 characters long.';
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter a URL')
                          : FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Image.network(_imageUrlController.text),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {}); // to rerander
                        },
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (value) => _editProduct =
                            Product.createUpdatedProduct(
                                'imageUrl', value as String, _editProduct),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please provide an image URL.';
                          if (!value.startsWith('http') &&
                              !value.startsWith('https'))
                            return 'Please enter a valid URL.';
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg'))
                            return 'Please enter a valid image URL.';
                          return null;
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
