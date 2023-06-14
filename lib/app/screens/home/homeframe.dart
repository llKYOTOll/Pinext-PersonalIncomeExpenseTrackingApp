import 'dart:io';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/app_settings_screen.dart';
import 'package:pinext/app/screens/home/pages/archive_page.dart';
import 'package:pinext/app/screens/home/pages/budget_page.dart';
import 'package:pinext/app/screens/home/pages/cards_and_balance_page.dart';
import 'package:pinext/app/screens/home/pages/home_page.dart';
import 'package:pinext/app/services/handlers/app_handler.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/shared/widgets/bounce_icons.dart';

class Homeframe extends StatefulWidget {
  const Homeframe({super.key});

  @override
  State<Homeframe> createState() => _HomeframeState();
}

class _HomeframeState extends State<Homeframe> {
  @override
  void initState() {
    super.initState();
    CardHandler().getUserCards();

    context.read<ArchiveCubit>().getCurrentMonthTransactionArchive(context);
    if (Platform.isAndroid) {
      // showNotification();
    }
  }

  Future<void> showIntroductions() async {
    final isFirstBoot = await AppHandler().checkIfFirstBoot();
    if (isFirstBoot) {
      await triggerIntroduction();
    }
  }

  Future<void> triggerIntroduction() async {
    await Future.delayed(const Duration(seconds: 1)).then((_) {
      Intro.of(context).start();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeframeCubit(),
        ),
      ],
      child: HomeframeView(),
    );
  }
}

List homeframePages = [const Homepage(), const ArchivePage(), const BudgetPage(), const CardsAndBalancePage(), const AppSettingsScreen()];

checkIfOldUser() {}

class HomeframeView extends StatelessWidget {
  HomeframeView({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     scaffoldKey.currentState!.openDrawer();
        //   },
        //   icon: IntroStepBuilder(
        //     order: 6,
        //     text: intro_label_six,
        //     builder: (context, introkey) {
        //       return const Icon(
        //         Icons.menu,
        //         color: customBlackColor,
        //       );
        //     },
        //   ),
        // ),
        centerTitle: true,
        title: Builder(
          builder: (context) {
            final demoBlocState = context.watch<DemoBloc>().state;
            return Text(
              demoBlocState is DemoEnabledState ? 'PINEXT : DEMO-MODE' : 'PINEXT',
              style: regularTextStyle.copyWith(
                fontSize: 16,
              ),
            );
          },
        ),
      ),
      // drawer: const PinextDrawer(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<HomeframeCubit, HomeframeState>(
              builder: (context, state) {
                return PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: homeframePages.length,
                  controller: state.pageController,
                  onPageChanged: (value) {
                    context.read<HomeframeCubit>().updateHomeframePage(value);
                  },
                  itemBuilder: (context, index) => homeframePages[index] as Widget,
                );
              },
            ),
          ),
          BlocBuilder<HomeframeCubit, HomeframeState>(
            builder: (context, state) {
              return Container(
                color: greyColor.withOpacity(.8),
                height: kToolbarHeight + 20,
                width: double.maxFinite,
                child: Row(
                  children: [
                    const SizedBox(
                      width: defaultPadding * 2,
                    ),
                    Flexible(
                      child: BounceIcon(
                        icon: state.selectedIndex == 0 ? AntIcons.homeFilled : AntIcons.homeOutlined,
                        size: 18,
                        title: state.selectedIndex == 0 ? 'Home' : null,
                        color: state.selectedIndex == 0 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                        onTap: () {
                          context.read<HomeframeCubit>().changeHomeframePage(0);
                        },
                      ),
                    ),
                    Flexible(
                      child: BounceIcon(
                        icon: state.selectedIndex == 1 ? AntIcons.databaseFilled : AntIcons.databaseOutlined,
                        size: 18,
                        title: state.selectedIndex == 1 ? 'Archive' : null,
                        color: state.selectedIndex == 1 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                        onTap: () {
                          context.read<HomeframeCubit>().changeHomeframePage(1);
                        },
                      ),
                    ),
                    Flexible(
                      child: BounceIcon(
                        icon: state.selectedIndex == 2 ? AntIcons.dollarCircleFilled : AntIcons.dollarCircleOutlined,
                        size: 18,
                        title: state.selectedIndex == 2 ? 'Budget' : null,
                        color: state.selectedIndex == 2 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                        onTap: () {
                          context.read<HomeframeCubit>().changeHomeframePage(2);
                        },
                      ),
                    ),
                    Flexible(
                      child: BounceIcon(
                        icon: state.selectedIndex == 3 ? AntIcons.walletFilled : AntIcons.walletOutlined,
                        size: 18,
                        title: state.selectedIndex == 3 ? 'Wallet' : null,
                        color: state.selectedIndex == 3 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                        onTap: () {
                          context.read<HomeframeCubit>().changeHomeframePage(3);
                        },
                      ),
                    ),
                    Flexible(
                      child: BounceIcon(
                        icon: state.selectedIndex == 4 ? AntIcons.appstoreFilled : AntIcons.appstoreOutlined,
                        size: 18,
                        title: state.selectedIndex == 4 ? 'More' : null,
                        color: state.selectedIndex == 4 ? darkPurpleColor : customBlackColor.withOpacity(.4),
                        onTap: () {
                          context.read<HomeframeCubit>().changeHomeframePage(4);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: defaultPadding * 2,
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // floatingActionButton: state.selectedIndex == 0 || state.selectedIndex == 2
      //     ? IntroStepBuilder(
      //         order: 1,
      //         text: intro_label_one,
      //         builder: (context, introkey) {
      //           return FloatingActionButton(
      //             onPressed: () {
      //               if (state.selectedIndex == 0) {
      //                 context.read<HomeframeCubit>().openAddTransactionsPage(context);
      //               } else if (state.selectedIndex == 2) {
      //                 Navigator.push(
      //                   context,
      //                   CustomTransitionPageRoute(
      //                     childWidget: AddSubscriptionPage(),
      //                   ),
      //                 );
      //               }
      //             },
      //             backgroundColor: customBlackColor,
      //             child: const Icon(
      //               Icons.add,
      //               color: whiteColor,
      //               size: 18,
      //             ),
      //           );
      //         },
      //       )
      //     : state.selectedIndex == 4
      //         ? FloatingActionButton(
      //             onPressed: () {
      //               context.read<HomeframeCubit>().showAboutDialog(context);
      //             },
      //             backgroundColor: customBlackColor,
      //             child: Text(
      //               '?',
      //               style: boldTextStyle.copyWith(
      //                 color: whiteColor,
      //                 fontSize: 16,
      //               ),
      //             ),
      //           )
      //         : const SizedBox.shrink(),
      // floatingActionButtonLocation: state.selectedIndex != 4 ? FloatingActionButtonLocation.miniEndTop : FloatingActionButtonLocation.endFloat,
      // bottomNavigationBar: BottomNavigationBar(
      //   key: key,
      //   currentIndex: state.selectedIndex,
      //   onTap: (value) {
      //     context.read<HomeframeCubit>().changeHomeframePage(value);
      //   },
      //   selectedItemColor: darkPurpleColor,
      //   unselectedItemColor: customBlackColor.withOpacity(.4),
      //   type: BottomNavigationBarType.fixed,
      //   // showSelectedLabels: false,
      //   // showUnselectedLabels: false,
      //   selectedLabelStyle: regularTextStyle.copyWith(
      //     fontSize: 12,
      //     color: darkPurpleColor,
      //   ),
      //   unselectedLabelStyle: regularTextStyle.copyWith(fontSize: 10),
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: IntroStepBuilder(
      //         order: 2,
      //         text: intro_label_two,
      //         builder: (context, introkey) {
      //           return Icon(
      //             state.selectedIndex == 0 ? AntIcons.homeFilled : AntIcons.homeOutlined,
      //             size: state.selectedIndex == 0 ? 20 : 16,
      //           );
      //         },
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: IntroStepBuilder(
      //         order: 3,
      //         text: intro_label_three,
      //         builder: (context, introkey) {
      //           return Icon(
      //             state.selectedIndex == 1 ? AntIcons.databaseFilled : AntIcons.databaseOutlined,
      //             size: state.selectedIndex == 1 ? 20 : 16,
      //           );
      //         },
      //       ),
      //       label: 'Archive',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         state.selectedIndex == 2 ? AntIcons.dollarCircleFilled : AntIcons.dollarCircleOutlined,
      //         size: state.selectedIndex == 2 ? 20 : 16,
      //       ),
      //       label: 'Budget',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: IntroStepBuilder(
      //         order: 4,
      //         text: intro_label_four,
      //         builder: (context, introkey) {
      //           return Icon(
      //             state.selectedIndex == 3 ? AntIcons.walletFilled : AntIcons.walletOutlined,
      //             size: state.selectedIndex == 3 ? 20 : 16,
      //           );
      //         },
      //       ),
      //       label: 'Wallet',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: IntroStepBuilder(
      //         order: 5,
      //         text: intro_label_five,
      //         builder: (context, introkey) {
      //           return Icon(
      //             state.selectedIndex == 4 ? AntIcons.appstoreFilled : AntIcons.appstoreOutlined,
      //             size: state.selectedIndex == 4 ? 20 : 16,
      //           );
      //         },
      //       ),
      //       label: 'More',
      //     ),
      //   ],
      // ),
    );
  }
}
