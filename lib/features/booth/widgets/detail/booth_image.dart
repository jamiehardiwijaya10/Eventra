import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';


class BoothImageCarousel extends StatefulWidget {

  final List<String> images;

  const BoothImageCarousel({
    super.key,
    required this.images,
  });

  @override
  State<BoothImageCarousel> createState() =>
      _BoothImageCarouselState();
}

class _BoothImageCarouselState
    extends State<BoothImageCarousel> {
  late PageController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          onPageChanged: (index){
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context,index){
            return Image.asset(
              widget.images[index],
              fit: BoxFit.cover,
            );
          },
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(
                    alpha: .35,
                  ),
                  Colors.transparent,
                  Colors.black.withValues(
                    alpha: .25,
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 45,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _CircleButton(
                icon: Icons.arrow_back,
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              _CircleButton(
                icon: Icons.bookmark_border,
                onTap: (){},
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
                  (index){
                return AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 300,
                  ),
                  margin:
                  const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  width: currentIndex == index
                      ? 24
                      : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index

                        ? Colors.white

                        : Colors.white54,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(50),

      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color:
          Colors.white.withValues(
            alpha: .9,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.black87,
        ),
      ),
    );
  }
}