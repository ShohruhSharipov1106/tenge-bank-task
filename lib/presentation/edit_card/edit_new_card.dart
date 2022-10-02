import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tenge_bank_test/constains.dart';
import 'package:tenge_bank_test/presentation/edit_card/components/card_type.dart';
import 'package:tenge_bank_test/presentation/edit_card/components/card_utilis.dart';
import 'package:tenge_bank_test/presentation/edit_card/components/input_formatters.dart';
import 'package:tenge_bank_test/presentation/home/home_page.dart';
import 'package:tenge_bank_test/provider/card_design_provider.dart';

class EditCardParametersScreen extends StatefulWidget {
  const EditCardParametersScreen({Key? key}) : super(key: key);

  @override
  State<EditCardParametersScreen> createState() =>
      _EditCardParametersScreenState();
}

class _EditCardParametersScreenState extends State<EditCardParametersScreen> {
  CardType cardType = CardType.Invalid;
  GlobalKey<FormState> _formkey = GlobalKey();
  void getCardTypeFrmNum() {
    String cardNum = CardUtils.getCleanedNumber(
        context.read<CardDesignProvider>().cardNumberController.text);
    CardType type = CardUtils.getCardTypeFrmNumber(cardNum);
    if (type != cardType) {
      setState(() {
        cardType = type;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<CardDesignProvider>().cardNumberController.addListener(() {
      getCardTypeFrmNum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Card"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: 2 * defaultPadding),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardNumber(context),
              _cardOwner(context),
              _cvvExpDate(context),
              
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                },
                child: Text("Confirm Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _cvvExpDate(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (value) =>
            context.read<CardDesignProvider>().expDateController.text.length !=
                    5
                ? "Incorrect Value"
                : null,
        controller: context.read<CardDesignProvider>().expDateController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
          CardMonthInputFormatter(),
        ],
        decoration: InputDecoration(
          hintText: "MM/YY",
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SvgPicture.asset("assets/icons/calender.svg"),
          ),
        ),
      ),
    );
  }

  Padding _cardOwner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: TextFormField(
        controller: context.read<CardDesignProvider>().cardOwnerController,
        validator: (value) =>
            context.read<CardDesignProvider>().cardOwnerController.text.length <
                    4
                ? "Incorrect value"
                : null,
        decoration: InputDecoration(
          hintText: "Full name",
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SvgPicture.asset("assets/icons/user.svg"),
          ),
        ),
      ),
    );
  }

  TextFormField _cardNumber(BuildContext context) {
    return TextFormField(
      controller: context.read<CardDesignProvider>().cardNumberController,
      keyboardType: TextInputType.number,
      validator: (value) =>
          context.read<CardDesignProvider>().cardNumberController.text.length !=
                  22
              ? "Incorrect value"
              : null,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        CardNumberInputFormatter(),
      ],
      decoration: InputDecoration(
        hintText: "Card number",
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SvgPicture.asset("assets/icons/card.svg"),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CardUtils.getCardIcon(cardType),
        ),
      ),
    );
  }
}
