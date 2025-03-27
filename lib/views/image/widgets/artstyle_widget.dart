import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify_ai/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';

class ArtStyleWidget extends StatelessWidget {
  final String text;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback? onClick;

  const ArtStyleWidget({super.key, required this.imageUrl, this.isSelected = false, this.onClick, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 118,
            height: 152,
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
              border: Border.all(width: 2, color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  width: 114,
                  height: 114,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: Container(
                        width: 114,
                        height: 114,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
