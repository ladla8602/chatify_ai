import 'package:flutter/material.dart';

enum PanelShape { rectangle, rounded }

enum DockType { inside, outside }

enum PanelState { open, closed }

class FloatingMenuPanel extends StatefulWidget {
  //final Function(bool) isOpen;
  final double? positionTop;
  final double? positionRight;
  final Color? borderColor;
  final double? borderWidth;
  final double? size;
  final double? iconSize;
  final IconData? panelIcon;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? contentColor;
  final PanelShape? panelShape;
  final PanelState? panelState;
  final double? panelOpenOffset;
  final int? panelAnimDuration;
  final Curve? panelAnimCurve;
  final DockType? dockType;
  final double? dockOffset;
  final int? dockAnimDuration;
  final Curve? dockAnimCurve;
  final List<IconData>? buttons;
  final VoidCallback? onMainPressed;
  final Function(int) onPressed;

  const FloatingMenuPanel({
    super.key,
    this.buttons,
    this.positionTop,
    this.positionRight,
    this.borderColor,
    this.borderWidth,
    this.iconSize,
    this.panelIcon,
    this.size,
    this.borderRadius,
    this.panelState,
    this.panelOpenOffset,
    this.panelAnimDuration,
    this.panelAnimCurve,
    this.backgroundColor,
    this.contentColor,
    this.panelShape,
    this.dockType,
    this.dockOffset,
    this.dockAnimCurve,
    this.dockAnimDuration,
    this.onMainPressed,
    required this.onPressed,
    //this.isOpen,
  });

  @override
  _FloatBoxState createState() => _FloatBoxState();
}

class _FloatBoxState extends State<FloatingMenuPanel> {
  // Required to set the default state to closed when the widget gets initialized;
  PanelState _panelState = PanelState.closed;

  // Default positions for the panel;
  double _positionTop = 0.0;
  double _positionRight = 0.0;

  // ** PanOffset ** is used to calculate the distance from the edge of the panel
  // to the cursor, to calculate the position when being dragged;
  double _panOffsetTop = 0.0;
  double _panOffsetLeft = 0.0;

  // This is the animation duration for the panel movement, it's required to
  // dynamically change the speed depending on what the panel is being used for.
  // e.g: When panel opened or closed, the position should change in a different
  // speed than when the panel is being dragged;
  int _movementSpeed = 0;

  @override
  void initState() {
    _positionTop = widget.positionTop ?? 0;
    _positionRight = widget.positionRight ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Width and height of page is required for the dragging the panel;
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;

    // All Buttons;
    List<IconData> buttons = widget.buttons!;

    // Dock offset creates the boundary for the page depending on the DockType;
    double dockOffset = widget.dockOffset ?? 20.0;

    // Widget size if the width of the panel;
    double widgetSize = widget.size ?? 70.0;

    // **** METHODS ****

    // Dock boundary is calculated according to the dock offset and dock type.
    double dockBoundary() {
      if (widget.dockType != null && widget.dockType == DockType.inside) {
        // If it's an 'inside' type dock, dock offset will remain the same;
        return dockOffset;
      } else {
        // If it's an 'outside' type dock, dock offset will be inverted, hence
        // negative value;
        return -dockOffset;
      }
    }

    // If panel shape is set to rectangle, the border radius will be set to custom
    // border radius property of the WIDGET, else it will be set to the size of
    // widget to make all corners rounded.
    BorderRadius borderRadius() {
      if (widget.panelShape != null && widget.panelShape == PanelShape.rectangle) {
        // If panel shape is 'rectangle', border radius can be set to custom or 0;
        return widget.borderRadius ?? BorderRadius.circular(0);
      } else {
        // If panel shape is 'rounded', border radius will be the size of widget
        // to make it rounded;
        return BorderRadius.circular(widgetSize);
      }
    }

    // Total buttons are required to calculate the height of the panel;
    double totalButtons() {
      if (widget.buttons == null) {
        return 0;
      } else {
        return widget.buttons!.length.toDouble();
      }
    }

    // Height of the panel according to the panel state;
    double panelHeight() {
      if (_panelState == PanelState.open) {
        // Panel height will be in multiple of total buttons, I have added "1"
        // digit height for each button to fix the overflow issue. Don't know
        // what's causing this, but adding "1" fixed the problem for now.
        return (widgetSize + (widgetSize + 1) * totalButtons()) + (widget.borderWidth ?? 0);
      } else {
        return widgetSize + (widget.borderWidth ?? 0) * 2;
      }
    }

    // Panel top needs to be recalculated while opening the panel, to make sure
    // the height doesn't exceed the bottom of the page;
    void calcPanelTop() {
      if (_positionTop + panelHeight() > pageHeight + dockBoundary()) {
        _positionTop = pageHeight - panelHeight() + dockBoundary();
      }
    }

    // Dock Left position when open;
    double openDockLeft() {
      if (_positionRight < (pageWidth / 2)) {
        // If panel is docked to the left;
        return widget.panelOpenOffset ?? 30.0;
      } else {
        // If panel is docked to the right;
        return ((pageWidth - widgetSize)) - (widget.panelOpenOffset ?? 30.0);
      }
    }

    // Panel border is only enabled if the border width is greater than 0;
    Border? panelBorder() {
      if (widget.borderWidth != null && widget.borderWidth! > 0) {
        return Border.all(
          color: widget.borderColor ?? Color(0xFF333333),
          width: widget.borderWidth ?? 0.0,
        );
      } else {
        return null;
      }
    }

    // Force dock will dock the panel to it's nearest edge of the screen;
    void forceDock() {
      // Calculate the center of the panel;
      double center = _positionRight + (widgetSize / 2);

      // Set movement speed to the custom duration property or '300' default;
      _movementSpeed = widget.dockAnimDuration ?? 300;

      // Check if the position of center of the panel is less than half of the
      // page;
      if (center < pageWidth / 2) {
        // Dock to the left edge;
        _positionRight = 0.0 + dockBoundary();
      } else {
        // Dock to the right edge;
        _positionRight = (pageWidth - widgetSize) - dockBoundary();
      }
    }

    // TODO implement close panel from screen without touch panel

    // Animated positioned widget can be moved to any part of the screen with
    // animation;
    return AnimatedPositioned(
      duration: Duration(
        milliseconds: _movementSpeed,
      ),
      top: _positionTop,
      right: _positionRight,
      curve: widget.dockAnimCurve ?? Curves.fastLinearToSlowEaseIn,

      // Animated Container is used for easier animation of container height;
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.panelAnimDuration ?? 600),
        width: widgetSize,
        height: panelHeight(),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Color(0xff00b0cb),
          borderRadius: borderRadius(),
          border: panelBorder(),
        ),
        curve: widget.panelAnimCurve ?? Curves.fastLinearToSlowEaseIn,
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            // Gesture detector is required to detect the tap and drag on the panel;
            GestureDetector(
              onPanEnd: (event) {
                setState(
                  () {
                    forceDock();
                  },
                );
              },
              onTapCancel: () {
                debugPrint('TAP_CANCEL');
              },
              onPanStart: (event) {
                // Detect the offset between the top and left side of the panel and
                // x and y position of the touch(click) event;
                _panOffsetTop = event.globalPosition.dy - _positionTop;
                _panOffsetLeft = event.globalPosition.dx - _positionRight;
              },
              onPanUpdate: (event) {
                setState(
                  () {
                    // Close Panel if opened;
                    _panelState = PanelState.closed;

                    // Reset Movement Speed;
                    _movementSpeed = 0;

                    // Calculate the top position of the panel according to pan;
                    _positionTop = event.globalPosition.dy - _panOffsetTop;

                    // Check if the top position is exceeding the dock boundaries;
                    if (_positionTop < 0 + dockBoundary()) {
                      _positionTop = 0 + dockBoundary();
                    }
                    if (_positionTop > (pageHeight - panelHeight()) - dockBoundary()) {
                      _positionTop = (pageHeight - panelHeight()) - dockBoundary();
                    }

                    // Calculate the Left position of the panel according to pan;
                    _positionRight = event.globalPosition.dx - _panOffsetLeft;

                    // Check if the left position is exceeding the dock boundaries;
                    if (_positionRight < 0 + dockBoundary()) {
                      _positionRight = 0 + dockBoundary();
                    }
                    if (_positionRight > (pageWidth - widgetSize) - dockBoundary()) {
                      _positionRight = (pageWidth - widgetSize) - dockBoundary();
                    }
                  },
                );
              },
              onTap: () {
                if (widget.onMainPressed != null) widget.onMainPressed!();
                setState(
                  () {
                    // Set the animation speed to custom duration;
                    _movementSpeed = widget.panelAnimDuration ?? 200;

                    if (_panelState == PanelState.open) {
                      // If panel state is "open", set it to "closed";
                      _panelState = PanelState.closed;

                      // Reset panel position, dock it to nearest edge;
                      forceDock();
                      //widget.isOpen(false);
                      //debugPrint("Float panel closed.");
                    } else {
                      // If panel state is "closed", set it to "open";
                      _panelState = PanelState.open;

                      // Set the left side position;
                      _positionRight = openDockLeft();
                      //widget.isOpen(true);

                      calcPanelTop();
                    }
                  },
                );
              },
              child: _FloatButton(
                size: widget.size ?? 70.0,
                icon: widget.panelIcon ?? Icons.settings,
                color: widget.contentColor ?? Colors.white,
                iconSize: widget.iconSize ?? 36.0,
              ),
            ),
            AnimatedOpacity(
              opacity: _panelState == PanelState.open ? 1.0 : 0.0,
              duration: _panelState == PanelState.open ? Duration(milliseconds: 250) : Duration(milliseconds: 10),
              child: Column(
                children: List.generate(
                  buttons.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onPressed(index);
                        setState(() {
                          _movementSpeed = widget.panelAnimDuration ?? 200;

                          if (_panelState == PanelState.open) {
                            // If panel state is "open", set it to "closed";
                            _panelState = PanelState.closed;

                            // Reset panel position, dock it to nearest edge;
                            forceDock();
                            //widget.isOpen(false);
                            ////debugPrint("Float panel closed.");
                          } else {
                            if (widget.onMainPressed != null) widget.onMainPressed!();
                            // If panel state is "closed", set it to "open";
                            _panelState = PanelState.open;

                            // Set the left side position;
                            _positionRight = openDockLeft();
                            // widget.isOpen(true);

                            calcPanelTop();
                          }
                        });
                      },
                      child: _FloatButton(
                        size: widget.size ?? 70.0,
                        icon: buttons[index],
                        color: widget.contentColor ?? Colors.white,
                        iconSize: widget.iconSize ?? 24.0,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatButton extends StatelessWidget {
  final double? size;
  final Color? color;
  final IconData? icon;
  final double? iconSize;

  const _FloatButton({this.size, this.color, this.icon, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: size ?? 70.0,
      height: size ?? 70.0,
      child: Icon(
        icon ?? Icons.settings,
        color: color ?? Colors.white,
        size: iconSize ?? 24.0,
      ),
    );
  }
}
