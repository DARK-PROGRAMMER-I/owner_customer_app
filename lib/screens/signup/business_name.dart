import 'package:WSHCRD/common/locatization.dart';
import 'package:WSHCRD/screens/owner/categories.dart';
import 'package:flutter/material.dart';

class BusinessName extends StatefulWidget {
  final Function businessNameAndCategory;

  const BusinessName({Key? key, required this.businessNameAndCategory})
      : super(key: key);

  @override
  _BusinessNameState createState() => _BusinessNameState();
}

class _BusinessNameState extends State<BusinessName> {
  String? businessName;
  String? category;

  navigateAndGetCategory() async {
    // Navigate and get the selected category
    var _category = await Navigator.pushNamed(
      context,
      Categories.routeName,
    );
    setState(() {
      category = _category.toString();
    });
    widget.businessNameAndCategory(businessName, category);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              AppLocalizations.of(context).translate('business_name'),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
              style: const TextStyle(fontWeight: FontWeight.bold),
              onChanged: (value) {
                // Set BusinessName
                setState(() {
                  businessName = value;
                });
                widget.businessNameAndCategory(businessName, category);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                hintText:
                    AppLocalizations.of(context).translate('store_name_hint'),
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(AppLocalizations.of(context).translate('select_category'),
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 10,
          ),
          Container(
            child: MaterialButton(
              onPressed: () => navigateAndGetCategory(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  category == null
                      ? Text(AppLocalizations.of(context).translate('select'),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.5)))
                      : Text(
                          category ?? "",
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                  const Icon(Icons.expand_more),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
