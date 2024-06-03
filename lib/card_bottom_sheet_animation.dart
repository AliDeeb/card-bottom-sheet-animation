import 'package:flutter/material.dart';

class CardBottomSheetAnimation extends StatefulWidget {
  const CardBottomSheetAnimation({
    super.key,
    required this.imagePath,
    required this.imageHeroTag,
    required this.cardTitle,
    required this.bottomSheetContent,
    this.cardHeight = 225,
    this.cardBorderRadius,
    this.bottomSheetRadius = 25,
    this.bottomSheetBackgroundColor,
  });

  final String imagePath;
  final String imageHeroTag;
  final Widget cardTitle;
  final double cardHeight;
  final BorderRadiusGeometry? cardBorderRadius;
  final Widget bottomSheetContent;
  final double bottomSheetRadius;
  final Color? bottomSheetBackgroundColor;

  @override
  State<CardBottomSheetAnimation> createState() =>
      _CardBottomSheetAnimationState();
}

class _CardBottomSheetAnimationState extends State<CardBottomSheetAnimation> {
  late double height;
  late BorderRadiusGeometry borderRadius;

  @override
  void initState() {
    super.initState();
    height = widget.cardHeight;
    borderRadius = widget.cardBorderRadius ?? BorderRadius.circular(15);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 20,
            ),
          ],
        ),
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BottomSheetAnimationScreen(
                      content: widget.bottomSheetContent,
                      imageHeroTag: widget.imageHeroTag,
                      imagePath: widget.imagePath,
                      bottomSheetRadius: widget.bottomSheetRadius,
                      backgroundColor: widget.bottomSheetBackgroundColor,
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image.
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: Row(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: widget.imageHeroTag,
                              child: Image.asset(
                                widget.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(child: widget.cardTitle)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheetAnimationScreen extends StatefulWidget {
  const BottomSheetAnimationScreen({
    super.key,
    required this.content,
    required this.imageHeroTag,
    required this.imagePath,
    required this.bottomSheetRadius,
    this.backgroundColor,
  });
  static const String routeName = "BottomSheetAnimation";

  final String imagePath;
  final String imageHeroTag;
  final double bottomSheetRadius;
  final Widget content;
  final Color? backgroundColor;

  @override
  State<BottomSheetAnimationScreen> createState() =>
      _BottomSheetAnimationScreenState();
}

class _BottomSheetAnimationScreenState extends State<BottomSheetAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;
  late Animation<double> backButtonAnimation;
  late Animation<double> cartButtonAnimation;
  late Size screenSize = MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 200),
    );

    animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    backButtonAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
    );

    cartButtonAnimation = Tween<double>(begin: 50, end: 100).animate(
      CurvedAnimation(parent: controller, curve: Curves.ease),
    );

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = screenSize.height * 0.45;
    final overlap = screenSize.height * 0.05;
    final bottomSheetHeight = (screenSize.height - imageHeight + overlap);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xfffafafa),
        body: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Stack(
            children: [
              // image.
              Hero(
                tag: widget.imageHeroTag,
                child: SizedBox(
                  height: imageHeight,
                  child: Image.asset(
                    widget.imagePath,
                    width: screenSize.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // bottom sheet.
              Positioned(
                top: imageHeight - overlap,
                child: SlideTransition(
                  position: animation,
                  child: Container(
                    width: screenSize.width,
                    height: bottomSheetHeight,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(widget.bottomSheetRadius),
                      ),
                    ),
                    child: widget.content,
                  ),
                ),
              ),

              // back button
              Positioned(
                top: screenSize.height * 0.03,
                child: ScaleTransition(
                  scale: backButtonAnimation,
                  child: FilledButton(
                    onPressed: () {
                      controller.reverse().then((_) {
                        Navigator.pop(context);
                      });
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
