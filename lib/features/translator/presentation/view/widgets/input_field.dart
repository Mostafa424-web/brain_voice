
import 'package:brain_voice/app_constance.dart';
import 'package:brain_voice/features/main/presentation/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/styles.dart';
import '../../../../main/manager/app_cubit/app_cubit.dart';

class InputField extends StatelessWidget {
   InputField({Key? key, required this.controller,required this.validate, this.onChange}) : super(key: key);

  final TextEditingController controller;
  final Function(String?)? onChange;
  final String? Function(String?)? validate;

    String textField = '';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 22),
        child: TextFormField(
          controller: controller,
          scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom ),
          onSaved: onChange,
          validator: validate,
          onChanged: (value) {
            // Scroll the ListView to the bottom when the user enters text
            AppCubit.get(context).scrollController.jumpTo(AppCubit.get(context).scrollController.position.maxScrollExtent);
          },
          scrollController: ScrollController(),
          decoration: InputDecoration(
            hintText: 'Type to translate'.padLeft(22),
            hintStyle: GoogleFonts.outfit(
              textStyle: Styles.textStyle16.copyWith(
                fontWeight: FontWeight.w400,
                color: const Color(0xffB9C0C9),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: (){
              },
              icon: const Icon(
                Icons.send,
                color: AppConstance.primaryColor,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            fillColor: const Color(0xffF9F9F9),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppConstance.primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            filled: true,
            prefixIcon: Container(
              decoration: const BoxDecoration(color: AppConstance.primaryColor),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(hearing: false),
                    ),
                  );
                },
              ),
            ),
            focusColor: AppConstance.primaryColor,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
      ),
    );
  }
}
