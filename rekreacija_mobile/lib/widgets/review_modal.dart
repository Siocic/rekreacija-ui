import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/review_insert_model.dart';
import 'package:rekreacija_mobile/providers/review_provider.dart';

class ReviewModal extends StatefulWidget {
  String userId;
  int objectId;
  ReviewModal({super.key, required this.userId, required this.objectId});
  final TextEditingController comment = TextEditingController();

  @override
  State<StatefulWidget> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  late ReviewProvider _reviewProvider;

  @override
  void initState() {
    super.initState();
    _reviewProvider = context.read<ReviewProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  const Text(
                    'Leave your review',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  FormBuilderField(
                    name: 'Rating',
                    validator: FormBuilderValidators.required(),
                    builder: (FormFieldState<double?> field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                            initialRating: field.value ?? 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              field.didChange(rating);
                            },
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(field.errorText ?? '',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: "Comment",
                    controller: widget.comment,
                    maxLines: 5,
                    maxLength: 100,
                    decoration: const InputDecoration(
                        labelText: 'Comment',
                        filled: true,
                        border: OutlineInputBorder()),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "The comment is required"),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState?.saveAndValidate() ??
                              false) {
                            try {
                              final formData = formKey.currentState!.fields;
                              final comment = formData['Comment']?.value ?? '';
                              final rating = formData['Rating']?.value ?? '';
                              DateTime created_date = DateTime.now();

                              ReviewInsertModel reviewInsert =
                                  ReviewInsertModel(
                                      comment,
                                      rating,
                                      created_date,
                                      widget.userId,
                                      widget.objectId);
                              await _reviewProvider.Insert(reviewInsert);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('You added a review successfully.'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.pop(context, true);
                            } catch (e) {
                              String errorMessage = e.toString();

                              if (errorMessage.startsWith("Exception:")) {
                                errorMessage = errorMessage
                                    .replaceFirst("Exception:", "")
                                    .trim();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please fix the errors in form.")));
                          }
                        },
                        child: const Text('Submit'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    ));
  }
}
