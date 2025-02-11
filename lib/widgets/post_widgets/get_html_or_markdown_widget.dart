// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:get/get.dart';
// import 'package:socialapp/features/posts/controllers/post_controller.dart';
// import 'package:socialapp/widgets/post_widgets/copy_text.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

// /// Converts Quill Delta JSON to HTML and renders it in a Flutter widget.
// Widget getHtmlOrMarkdownWidget(dynamic body, PostController controller) {
//   try {
//     // Decode JSON if it's a string
//     final dynamic decodedBody = body is String ? jsonDecode(body) : body;

//     // Ensure the decoded body is a List<Map<String, dynamic>>
//     if (decodedBody is List) {
//       final List<Map<String, dynamic>> deltaList = decodedBody
//           .cast<Map<String, dynamic>>(); // Ensure correct type casting

//       int len2 = controller.showFullPost.isTrue
//           ? deltaList.length
//           : (deltaList.length / 2).ceil() > 6
//               ? ((deltaList.length / 2).ceil() / 2).ceil()
//               : (deltaList.length / 2).ceil();

//       List<Map<String, dynamic>> l =
//           deltaList.length > 6 ? deltaList.sublist(0, len2) : deltaList;

//       // Convert Quill Delta to HTML
//       final html = QuillDeltaToHtmlConverter(l).convert();
//       print("Converted to HTML successfully.");

//       // Return the HTML widget
//       return Column(
//         children: [
//           InkWell(
//             onTap: () {
//               if (controller.showFullPost.isTrue && deltaList.length > 6) {
//                 controller.handleToggleFullPost();
//               }
//             },
//             child: Html(
//               data: html,
//               onLinkTap: (url, _, __) {
//                 if (url != null) {
//                   launchUrlString(url); // Launch the URL if it's not null
//                 }
//               },
//             ),
//           ),
//           if (controller.showFullPost.isFalse && deltaList.length > 6)
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () {
//                   controller.handleToggleFullPost();
//                 },
//                 child: Text("show_more".tr),
//               ),
//             ),
//         ],
//       );
//     } else {
//       throw FormatException("Decoded body is not a valid Quill Delta format.");
//     }
//   } catch (e) {
//     if (controller.showFullPost.isTrue) {
//       return InkWell(
//         onTap: () {
//           controller.handleToggleFullPost();
//         },
//         onLongPress: () =>
//             copyText(Get.context!, controller.post.value?.body ?? ""),
//         child: MarkdownBody(
//           selectable: false,
//           data: controller.post.value?.body ?? "",
//         ),
//       );
//     }
//     // Fallback: Return plain text representation of the body
//     return Column(
//       children: [
//         if (controller.post.value!.body!.length > 500)
//           Column(
//             children: [
//               InkWell(
//                 onTap: () {
//                   if (controller.post.value!.body!.length > 500) {
//                     controller.handleToggleFullPost();
//                   }
//                 },
//                 onLongPress: () =>
//                     copyText(Get.context!, controller.post.value?.body ?? ""),
//                 child: MarkdownBody(
//                   selectable: false,
//                   data: controller.post.value!.body!.length > 500
//                       ? "${controller.post.value?.body!.substring(0, 500)} ..."
//                       : controller.post.value?.body ?? "",
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: double.infinity,
//                 child: TextButton(
//                   onPressed: () {
//                     controller.handleToggleFullPost();
//                   },
//                   child: Text("show_more".tr),
//                 ),
//               ),
//             ],
//           )
//         else
//           InkWell(
//             onTap: () {
//               controller.handleToggleFullPost();
//             },
//             onLongPress: () =>
//                 copyText(Get.context!, controller.post.value?.body ?? ""),
//             child: MarkdownBody(
//               selectable: false,
//               data: controller.post.value?.body ?? "",
//             ),
//           ),
//       ],
//     );
//   }
// }
