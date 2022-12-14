import 'package:WSHCRD/locator.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/screens/customer/home/customer_home.dart';
import 'package:WSHCRD/screens/customer/nearby/nearby_view.dart';
import 'package:WSHCRD/screens/customer/profile/customer_edit_profile.dart';
import 'package:WSHCRD/screens/customer/profile/customer_profile.dart';
import 'package:WSHCRD/screens/customer/request/accept_bid.dart';
import 'package:WSHCRD/screens/customer/request/new_request.dart';
import 'package:WSHCRD/screens/customer/request/new_request_second.dart';
import 'package:WSHCRD/screens/customer/request/request_home.dart';
import 'package:WSHCRD/screens/customer/request/request_preview.dart';
import 'package:WSHCRD/screens/customer/request/see_bids_view.dart';
import 'package:WSHCRD/screens/owner/add_bid/add_bid_view.dart';
import 'package:WSHCRD/screens/owner/add_bid/bid_posted_view.dart';
import 'package:WSHCRD/screens/owner/categories.dart';
import 'package:WSHCRD/screens/owner/credit_book/add_customer.dart';
import 'package:WSHCRD/screens/owner/credit_book/credit_book.dart';
import 'package:WSHCRD/screens/owner/credit_book/get_or_give_payment.dart';
import 'package:WSHCRD/screens/owner/credit_book/payment_view.dart';
import 'package:WSHCRD/screens/owner/my_bids/bid_details_view.dart';
import 'package:WSHCRD/screens/owner/my_bids/my_bids.dart';
import 'package:WSHCRD/screens/owner/nearby/nearby_view.dart';
import 'package:WSHCRD/screens/owner/orders_view.dart';
import 'package:WSHCRD/screens/owner/owner_home_screen.dart';
import 'package:WSHCRD/screens/owner/profile/owner_edit_profile.dart';
import 'package:WSHCRD/screens/owner/profile/owner_profile.dart';
import 'package:WSHCRD/screens/signup/pick_location.dart';
import 'package:WSHCRD/screens/signup/signup_screen.dart';
import 'package:WSHCRD/screens/start.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Start.routeName:
        Start view = locator<Start>();
        return MaterialPageRoute(
            builder: (_) => view,
            settings: const RouteSettings(name: Start.routeName));
      case AddCustomer.routeName:
        AddCustomer view = locator<AddCustomer>();
        return MaterialPageRoute(
            builder: (_) => view,
            settings: const RouteSettings(name: AddCustomer.routeName));
      case CreditBook.routeName:
        CreditBook view = locator<CreditBook>();
        return MaterialPageRoute(
            builder: (_) => view,
            settings: const RouteSettings(name: CreditBook.routeName));
      case GetOrGivePayment.routeName:
        GetOrGivePayment view = locator<GetOrGivePayment>();
        if (settings.arguments != null) {
          view.setValues(settings.arguments as Map<String,dynamic>);
        }
        return MaterialPageRoute(
            builder: (_) => view,
            settings: const RouteSettings(name: GetOrGivePayment.routeName));
      case PaymentView.routeName:
        PaymentView view = locator<PaymentView>();
        if (settings.arguments != null) {
          view.setValues(settings.arguments  as Map<String,dynamic>);
        }
        return MaterialPageRoute(
            builder: (_) => view,
            settings: const RouteSettings(name: PaymentView.routeName));
      case SignUpScreen.routeName:
        SignUpScreen view = locator<SignUpScreen>();
        if (settings.arguments != null) {
          view.setValues(settings.arguments  as Map<String,dynamic>);
        }
        return MaterialPageRoute(
            builder: (_) => view,
            settings: const RouteSettings(name: SignUpScreen.routeName));

      case MyBidsView.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<MyBidsView>(),
            settings: const RouteSettings(name: MyBidsView.routeName));
      case BidDetailsView.routeName:
        return MaterialPageRoute(
            builder: (_) {
              BidDetailsViewArguments args = settings.arguments as BidDetailsViewArguments ;
              return BidDetailsView(
                bid: args.bid,
              );
            },
            settings: RouteSettings(
                name: BidDetailsView.routeName, arguments: settings.arguments));
      case OrdersView.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<OrdersView>(),
            settings: const RouteSettings(name: OrdersView.routeName));
      case OwnerProfile.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<OwnerProfile>(),
            settings: const RouteSettings(name: OwnerProfile.routeName));
      case OwnerHomeScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<OwnerHomeScreen>(),
            settings: const RouteSettings(name: OwnerHomeScreen.routeName));
      case OwnerNearByView.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<OwnerNearByView>(),
            settings: const RouteSettings(name: OwnerNearByView.routeName));
      case AddBidView.routeName:
        return MaterialPageRoute(
            builder: (_) => AddBidView(),
            settings: RouteSettings(
                name: AddBidView.routeName, arguments: settings.arguments));
      case BidPostedView.routeName:
        return MaterialPageRoute(
            builder: (_) {
              BidPostedViewArguments args = settings.arguments as BidPostedViewArguments;
              return BidPostedView(
                  request: args.request,
                  bid: args.bid,
                );
              },
            settings: RouteSettings(
                name: BidPostedView.routeName, arguments: settings.arguments));
      case OwnerEditProfile.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<OwnerEditProfile>(),
            settings: const RouteSettings(name: OwnerEditProfile.routeName));
      case CustomerEditProfile.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<CustomerEditProfile>(),
            settings: const RouteSettings(name: CustomerEditProfile.routeName));
      case Categories.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<Categories>(),
            settings: const RouteSettings(name: Categories.routeName));
      case PickLocation.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<PickLocation>(),
            settings: const RouteSettings(name: PickLocation.routeName));
      case CustomerHomeScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<CustomerHomeScreen>(),
            settings: const RouteSettings(name: CustomerHomeScreen.routeName));
      case NewRequestView.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<NewRequestView>(),
            settings: const RouteSettings(name: NewRequestView.routeName));
      case NewRequestSecondView.routeName:
        NewRequestSecondView view = locator<NewRequestSecondView>();
        if (settings.arguments != null) {
          Object? values = settings.arguments;
          view.setRequest(Request.fromJson(values  as Map<String,dynamic>));
        }
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => view,
          settings: const RouteSettings(name: NewRequestSecondView.routeName),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        );

//        return MaterialPageRoute(
//            builder: (_) => view,
//            settings: RouteSettings(name: NewRequestSecondView.routeName));
      case RequestPreviewView.routeName:
        RequestPreviewView view = locator<RequestPreviewView>();
        if (settings.arguments != null) {
          Object? values = settings.arguments;
          view.setRequest(Request.fromJson(values  as Map<String,dynamic>));
        }
        return MaterialPageRoute(
            builder: (_) => view,
            settings: const RouteSettings(name: RequestPreviewView.routeName));
      case RequestHomeView.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<RequestHomeView>(),
            settings: const RouteSettings(name: RequestHomeView.routeName));
      case SeeBidsView.routeName:
        return MaterialPageRoute(
            builder: (_) {
              SeeBidsViewArguments args = settings.arguments as SeeBidsViewArguments;
              return SeeBidsView(
                request: args.request,
              );
            },
            settings: RouteSettings(
                name: SeeBidsView.routeName, arguments: settings.arguments));
      case AcceptBidView.routeName:
        return MaterialPageRoute(
            builder: (_) {
              AcceptBidViewArguments args = settings.arguments as AcceptBidViewArguments;
              return AcceptBidView(
                bid: args.bid,
              );
            },
            settings: RouteSettings(
                name: AcceptBidView.routeName, arguments: settings.arguments));
      case CustomerNearByView.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<CustomerNearByView>(),
            settings: const RouteSettings(name: CustomerNearByView.routeName));

      case CustomerProfileView.routeName:
        return MaterialPageRoute(
            builder: (_) => locator<CustomerProfileView>(),
            settings: const RouteSettings(name: CustomerProfileView.routeName));

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}

class AddBidViewArguments {
  final Request request;

  AddBidViewArguments(this.request);
}
