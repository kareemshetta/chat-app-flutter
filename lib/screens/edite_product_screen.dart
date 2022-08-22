import 'package:flutter/material.dart';
import '../provider/product.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-screeen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
      id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
      isFavourite: false);
  var intialValues = {
    'id': null,
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
    'isFavourite': false
  };
  var isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        String id = productId as String;
        _editedProduct = Provider.of<Products>(context).findById(id);
        intialValues = {
          'id': _editedProduct.id,
          'price': _editedProduct.price,
          'title': _editedProduct.title,
          'imageUrl': _editedProduct.imageUrl,
          'isFavourite': _editedProduct.isFavourite,
          'description': _editedProduct.description
        };
        _imageUrlController.text = _editedProduct.imageUrl!;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  var _isLoading = false;

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    // we attach listener to focus node
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValidate = _form.currentState!.validate();
    if (!isValidate) return;
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('something went wrong'),
                content: Text('check your own connection'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop('nooooo');
                      },
                      child: Text('Okey'))
                ],
              );
            });
      }
      // finally{
      //   setState(() {
      //     _isLoading = false;
      //     print('poppppppppppppppppppppppppppppppppp');
      //   });
      //   Navigator.of(context).pop();
      // }

    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    // we use it to rebuild so image can show when we lose focus
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                // this we pass our global key
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('title'),
                      ),
                      // the shape pf submit button
                      textInputAction: TextInputAction.next,
                      initialValue: intialValues['title'] as String,
                      // here we validate our input
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please input a title';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        // this means  _priceFocusNode request focus
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      // we form save data
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('price'),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      initialValue: intialValues['price'].toString(),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Description'),
                      ),
                      initialValue: intialValues['description'] as String,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      // textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          imageUrl: _editedProduct.imageUrl,
                          description: value,
                          price: _editedProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter description';
                        }
                        if (value.length < 10) {
                          return 'this is short description enter a long one';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5, right: 6),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('input url')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: Text('Image Url'),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                id: _editedProduct.id,
                                imageUrl: value,
                                isFavourite: _editedProduct.isFavourite,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                              );
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              // true true
                              //true  false
                              if (!value!.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return 'please enter a valid url';
                              }
                              // true  && true && true
                              //true true false
                              if (!value.endsWith('png') &&
                                  !value.endsWith('jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'please enter a valid image url';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
