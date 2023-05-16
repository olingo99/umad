import 'package:flutter/material.dart';
import 'package:umad/models/UserModel.dart';
import '../services/userService.dart';


class CountryFormField extends StatefulWidget {
  const CountryFormField({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;
  @override
  _CountryFormFieldState createState() => _CountryFormFieldState();
}

class _CountryFormFieldState extends State<CountryFormField>
    with TickerProviderStateMixin {
// focus node object to detect gained or loss on textField
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  GlobalKey globalKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  final UserService userService = UserService();
  List<String> suggestions =  [];

  @override
  void initState() {
    super.initState();
    OverlayState? overlayState = Overlay.of(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      globalKey;
    });
  
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
              _overlayEntry = _createOverlay();

        overlayState!.insert(_overlayEntry!);
      } else {
       _overlayEntry!.remove();
      }
    });
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    var size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 5.0,
                  child: FutureBuilder(
                    future: userService.getAllUserNames(widget.controller.text),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        suggestions = snapshot.data??[];
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(suggestions[index]),
                              onTap: () {
                                _focusNode.unfocus();
                                setState(() {
                                  widget.controller.text = suggestions[index];
                                });
                              },
                            );
                          }
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ));
  }

// ListView.builder(
//                     itemCount: suggestions.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(suggestions[index]),
//                         onTap: () {
//                           _focusNode.unfocus();
//                           setState(() {
//                             _controller.text = suggestions[index];
//                           });
//                         },
//                       );
//                     }
//                   )

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        // key: globalKey,
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        onChanged: (text){
          print("text");
          print(text);
          setState(() {
            // _controller.text = text;
          });
        },
        // decoration: kTextInputDecoration.copyWith(labelText: 'Country Name'),
      ),
    );
  }
}