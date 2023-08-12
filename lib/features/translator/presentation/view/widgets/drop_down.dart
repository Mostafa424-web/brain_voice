import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../../app_constance.dart';
import '../../model/menu_item.dart';

class DropDownIcon extends StatelessWidget {
  const DropDownIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          margin: const EdgeInsets.only(
            left: 128,
            right: 128,
          ),
          decoration: const BoxDecoration(
              color: AppConstance.primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50))),
          child: const Icon(
            Icons.arrow_drop_down_sharp,
            size: 25,
            color: Colors.white,
          ),
        ),
        items: [
          ...MenuItems.firstItems.map(
                (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          const DropdownMenuItem<Divider>(
              enabled: false, child: Divider()),
          ...MenuItems.secondItems.map(
                (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppConstance.primaryColor,
          ),
          elevation: 8,
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
            ...List<double>.filled(MenuItems.secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}