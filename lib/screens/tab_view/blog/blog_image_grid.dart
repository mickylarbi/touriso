import 'package:flutter/material.dart';
import 'package:touriso/utils/dimensions.dart';

class BlogImageGrid extends StatelessWidget {
  const BlogImageGrid({super.key, required this.imageUrls});
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 1) {
      return Image.network(
        imageUrls[0],
        width: kScreenWidth(context) - 48,
        fit: BoxFit.cover,
      );
    }

    if (imageUrls.length == 2) {
      return SizedBox(
        height: (kScreenWidth(context) - 48 - 10) / 2,
        child: Row(
          children: List.generate(
            imageUrls.length,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 10,
                  right: index == 0 ? 10 : 0,
                ),
                child: Image.network(imageUrls[index], fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      );
    }

    if (imageUrls.length == 3) {
      return SizedBox(
        height: (kScreenWidth(context) - 48) / 2,
        child: Row(
          children: [
            Expanded(
              child: Image.network(
                imageUrls[0],
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      imageUrls[1],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Image.network(
                      imageUrls[2],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (imageUrls.length == 4) {
      return SizedBox(
        height: (kScreenWidth(context) - 48) / 2,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      imageUrls[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Image.network(
                      imageUrls[1],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      imageUrls[2],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Image.network(
                      imageUrls[3],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (imageUrls.length == 5) {
      return SizedBox(
        height: (kScreenWidth(context) - 48) / 2,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      imageUrls[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Image.network(
                      imageUrls[1],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      imageUrls[2],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: IconButton(
                      onPressed: () {},
                      icon: Text('+${imageUrls.length - 3}'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
