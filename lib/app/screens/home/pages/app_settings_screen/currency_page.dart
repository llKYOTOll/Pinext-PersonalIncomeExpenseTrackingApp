import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
import 'package:pinext/country_data/country_data.dart';

class CurrencyPage extends StatelessWidget {
  const CurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: customBlackColor,
          ),
        ),
        title: Text(
          'Select Currency',
          style: regularTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: CountryHandler().countryList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          UserHandler().currentUser.currencySymbol = CountryHandler().countryList[index].symbol;
                        },
                        child: Container(
                          height: 50,
                          width: getWidth(context),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(defaultBorder),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${CountryHandler().countryList[index].currency} - ${CountryHandler().countryList[index].symbol}',
                                style: regularTextStyle.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                              if (UserHandler().currentUser.currencySymbol == CountryHandler().countryList[index].symbol)
                                const Icon(
                                  Icons.check,
                                  color: primaryColor,
                                )
                              else
                                const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                      const Divider()
                    ],
                  );
                },
              ),
              const SizedBox(
                height: kToolbarHeight,
              )
            ],
          ),
        ),
      ),
    );
  }
}
