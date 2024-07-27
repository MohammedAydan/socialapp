import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';

class EditPostScreen extends StatelessWidget {
  static const String routeName = "/EditPost";
  const EditPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit_post".tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  maxLength: 5000,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: Text(
                      "enter_your_post_post".tr,
                      style: TextStyle(
                        color: context.theme.colorScheme.secondary,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  width: 1,
                  color: context.theme.colorScheme.secondary,
                ),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.perm_media_outlined,
                  color: context.theme.colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.tertiary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField(
                value: "public",
                dropdownColor: context.theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(15),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: context.theme.colorScheme.surface,
                ),
                items: [
                  DropdownMenuItem(value: "public", child: Text("public".tr)),
                  DropdownMenuItem(value: "private", child: Text("private".tr)),
                ],
                onChanged: (v) {},
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 150,
              child: CustomPrimaryButton(text: "post".tr, onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
