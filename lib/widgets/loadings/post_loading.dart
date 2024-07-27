import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostLoading extends StatelessWidget {
  const PostLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.tertiary,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 200,
                      height: 10,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: 200,
            height: 10,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 300,
            height: 10,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: context.theme.colorScheme.surface),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
