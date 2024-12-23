import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonElevatedButtonWidget extends StatelessWidget {
  final SvgPicture? imagePath;
  final String text;
  final Color? color;
  final bool isLoading;
  final VoidCallback onClick;
  const CommonElevatedButtonWidget(
      {super.key,
      this.imagePath,
      required this.text,
      required this.onClick,
      this.color = const Color(0xff6298F0),
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;
    return ElevatedButton(
      onPressed: isLoading ? null : onClick,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        )),
        // minimumSize: WidgetStateProperty.all(Size(buttonWidth, 48)),
        // maximumSize: WidgetStateProperty.all(Size(buttonWidth, 48)),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePath != null)
                Container(
                  height: 48,
                  width: 48,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24)),
                  ),
                  child: imagePath,
                ),
              const SizedBox(width: 40),
              SizedBox(
                // width: buttonWidth - 48,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              child: isLoading
                  ? SizedBox(
                      width: buttonWidth - 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            padding: const EdgeInsets.all(8.0),
                            child: const CircularProgressIndicator.adaptive(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink())
        ],
      ),
    );
  }
}

// class CommonBtn extends StatelessWidget {
//   final Color? color;
//   final Color borC;
//   final Color? decorationC;
//   final String text;
//   final VoidCallback? click;
//   final bool isLoading;
//   const CommonBtn(
//       {super.key,
//       this.color,
//       required this.borC,
//       this.click,
//       this.text = "",
//       this.decorationC,
//       this.isLoading = false});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : click,
//       child: Stack(
//         children: [
//           Container(
//               alignment: Alignment.center,
//               width: MediaQuery.of(context).size.width,
//               height: 48,
//               decoration: BoxDecoration(
//                   color: decorationC,
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(width: 1, color: borC)),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                     fontSize: 13, color: color, fontWeight: FontWeight.bold),
//               )),
//           Positioned(
//               left: 0,
//               right: 0,
//               child: isLoading
//                   ? SizedBox(
//                       width: 48,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 48,
//                             width: 48,
//                             padding: const EdgeInsets.all(8.0),
//                             child: const CircularProgressIndicator.adaptive(
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : SizedBox.shrink())
//         ],
//       ),
//     );
//   }
// }

class OutlinebuttonWigets extends StatelessWidget {
  final String text;
  final Color? color;
  final String logo;
  final VoidCallback? onClick;
  final bool isLoading;
  const OutlinebuttonWigets(
      {super.key,
      required this.text,
      this.onClick,
      this.isLoading = false,
      this.color = Colors.black,
      required this.logo});

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;
    return Stack(
      children: [
        SizedBox(
          height: 48,
          width: MediaQuery.of(context).size.width,
          child: OutlinedButton(
            onPressed: onClick,
            style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 1,
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                )),
            child: Stack(
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    child: isLoading
                        ? SizedBox(
                            width: buttonWidth - 48,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      const CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
        Positioned(
          left: 14,
          top: 0,
          bottom: 0,
          child: Image.asset(
            logo,
            height: 24,
            width: 24,
          ),
        ),
      ],
    );
  }
}

class Createbtn extends StatelessWidget {
  final String? image;
  final String text;
  final Color? color;
  final VoidCallback? onClick;
  const Createbtn(
      {super.key, this.image, this.color, required this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.only(
          left: 1,
        ),
        width: MediaQuery.of(context).size.width,
        height: 48,
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.surface,
          color: color,
          borderRadius: BorderRadius.circular(24),
          // border: Border.all(
          //     width: 1,
          //     style: BorderStyle.solid,
          //     color: Theme.of(context).colorScheme.onPrimary)
        ),
        child: Row(
          children: [
            Image(image: AssetImage(image.toString())),
            const SizedBox(width: 25),
            Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class ElevatedButtonWigets extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onClick;
  const ElevatedButtonWigets(
      {super.key,
      required this.text,
      this.backgroundColor,
      this.onClick,
      this.foregroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: onClick,
          child: Text(text)),
    );
  }
}
