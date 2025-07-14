import 'package:flutter/material.dart';

class MySearchbar extends StatefulWidget {
  final Function(String)? onChange;
  final String? placeholder;
  final String? initialValue;
  final bool isVisible;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const MySearchbar({
    super.key,
    this.onChange,
    this.placeholder = "Search...",
    this.initialValue = "",
    required this.isVisible,
    this.margin,
    this.padding,
  });

  @override
  State<MySearchbar> createState() => _MySearchbarState();
}

class _MySearchbarState extends State<MySearchbar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);

    // Setup animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Setup animations
    _heightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Set initial animation state
    if (widget.isVisible) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(MySearchbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle visibility changes
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
        // Focus when becoming visible
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _focusNode.requestFocus();
          }
        });
      } else {
        _animationController.reverse();
        _focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged(String value) {
    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  void _clearText() {
    _controller.clear();
    if (widget.onChange != null) {
      widget.onChange!("");
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SizeTransition(
            sizeFactor: _heightAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 60.0),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _handleTextChanged,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    suffixIcon:
                        _controller.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                              onPressed: _clearText,
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
