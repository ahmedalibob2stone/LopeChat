import 'package:flutter/material.dart';

import '../../../common/widgets/Buttom_container.dart';
import '../../../constant.dart';
class Welcome_Screan extends StatelessWidget {
  const Welcome_Screan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 70,),
            Text("welcom to  Chat Lope",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30),),
            SizedBox(height:MediaQuery.of(context).size.height/9),
            Expanded(
              child: Image.asset(
                'assets/images/logo_image.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height:MediaQuery.of(context).size.height/9),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Read our Privacy .Tap "Agree and continue" to accept the Terms of Services. ',style:
              TextStyle(fontWeight: FontWeight.w600,color: Colors.black,),
              textAlign: TextAlign.center,
              ),

            ),
            const SizedBox(height: 20,),
            ButtonContainerWidget(

              color: kkPrimaryColor,text: 'Agree And Continue',onTapListener: (){
              Navigator.pushNamedAndRemoveUntil(context, PageConst.LoginScrean ,(route) => false);

            },),
            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}
