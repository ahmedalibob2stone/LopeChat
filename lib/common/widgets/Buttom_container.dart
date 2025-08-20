import 'package:flutter/material.dart';



class ButtonContainerWidget extends StatefulWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;
  const ButtonContainerWidget({Key? key, this.color, this.text, this.onTapListener}) : super(key: key);

  @override
  State<ButtonContainerWidget> createState() => _ButtonContainerWidgetState();
}

class _ButtonContainerWidgetState extends State<ButtonContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTapListener,
      child: Container(
        width: 322,
        height: 40,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(child: Text("${widget.text}", style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.w600),),),
      ),
    );
  }
}



