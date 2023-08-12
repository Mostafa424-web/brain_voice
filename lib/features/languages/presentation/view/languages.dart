import 'package:brain_voice/core/utils/assets_manager.dart';
import 'package:brain_voice/core/utils/styles.dart';
import 'package:brain_voice/features/languages/models/lamguage_model.dart';
import 'package:brain_voice/features/main/manager/app_cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableLanguage extends StatefulWidget {
  const AvailableLanguage({Key? key}) : super(key: key);

  @override
  State<AvailableLanguage> createState() => _AvailableLanguageState();
}

class _AvailableLanguageState extends State<AvailableLanguage> {
  @override
  Widget build(BuildContext context) {
    List<LanguageModel> languages = [
      const LanguageModel(title: 'English', image: ImageAssets.usaImage),
      const LanguageModel(
          title: 'Portuguese', image: ImageAssets.portoImage),
      const LanguageModel(title: 'Egypt', image: ImageAssets.egyptImage),
      const LanguageModel(title: 'japanese', image: ImageAssets.japanImage),
    ];
     
    bool isClicked = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 77,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Languages',
                style: Styles.textStyle24,
              ),
            ),
            AppCubit.get(context).buildSizedBox(37),
            const SearchField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              child: ListView.separated(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10),
                        ),
                        side: BorderSide(color: Colors.black12)
                      ),
                      trailing: isClicked ? const Icon(FontAwesomeIcons.check) : null,
                      onTap: () {
                          setState(() {
                          isClicked = !isClicked;
                          });
                      },
                      leading: Image.asset(
                        languages[index].image,
                        width: 30,
                        height: 30,
                      ),
                      title: Text(
                        languages[index].title,
                        style: GoogleFonts.outfit(
                          textStyle: Styles.textStyle16,
                        ),
                      ),
                    );
                  },
              separatorBuilder: (context , index) {
                    return AppCubit.get(context).buildSizedBox(15);
              },),
            )
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          fillColor: Color(0xffF9F9F9),
          filled: true,
          hintText: 'Search language',
          prefixIcon: Icon(
            FontAwesomeIcons.search,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          )),
    );
  }
}
