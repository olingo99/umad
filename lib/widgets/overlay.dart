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
    late Future<List<String>> suggestionsFuture;
  final UserService userService = UserService();

  List<String> suggestions = [];

  Widget test = Container();


  @override
  void initState() {
    super.initState();
    OverlayState? overlayState = Overlay.of(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      globalKey;
    });
  
    widget.controller.addListener(() {
      _overlayEntry = _createOverlay();
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
    suggestionsFuture = userService.getAllUserNames(widget.controller.text);
    var size = renderBox.size;
    test = futureSuggestions(controller: widget.controller, focusNode: _focusNode, suggestions: suggestions, suggestionsFuture: suggestionsFuture,);
    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 5.0,
                  child: test,
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
          suggestionsFuture = userService.getAllUserNames(text);
          widget.controller.notifyListeners();

          setState(() {
            // _controller.text = text;
          });
        },
        // decoration: TextInputDecoration.copyWith(labelText: 'Country Name'),
      ),
    );
  }
}

class futureSuggestions extends StatefulWidget {
  futureSuggestions({super.key, required this.controller, required this.focusNode, required this.suggestions, required this.suggestionsFuture});
  final TextEditingController controller;
  List<String> suggestions;
  final FocusNode focusNode;
  late Future<List<String>> suggestionsFuture;
  @override
  State<futureSuggestions> createState() => _futureSuggestionsState();
}

class _futureSuggestionsState extends State<futureSuggestions> {
  final UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    print("build");
    return FutureBuilder(
                    future: widget.suggestionsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        widget.suggestions = snapshot.data??[];
                        return     ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: widget.suggestions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(widget.suggestions[index]),
                              onTap: () {
                                widget.focusNode.unfocus();
                                setState(() {
                                  widget.controller.text = widget.suggestions[index];
                                });
                              },
                            );
                          }
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
    
    

  }
}