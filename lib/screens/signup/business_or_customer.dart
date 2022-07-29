import 'package:WSHCRD/common/locatization.dart';
import 'package:flutter/material.dart';

class BusinessOrCustomer extends StatefulWidget {
  final Function businessOrNot;

  const BusinessOrCustomer({Key? key, required this.businessOrNot})
      : super(key: key);

  @override
  _BusinessOrCustomerState createState() => _BusinessOrCustomerState();
}

class _BusinessOrCustomerState extends State<BusinessOrCustomer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('business_question'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 75,
          ),
          InkWell(
            onTap: () {
              widget.businessOrNot(1);
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 3 / 5,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black, width: 2)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate('yes'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              widget.businessOrNot(0);
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 3 / 5,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black, width: 2)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate('no'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              widget.businessOrNot(1);
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 3 / 5,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black, width: 2)),
                elevation: 10,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Center(
                    child: Text(
                      "I'M A WHOLESALER",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
