import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideshare/screens/maps.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late ScrollController _scrollController;
  late final PageController _c = PageController(
    initialPage: 0,
  );

  double offset = 0.0;
  static final _isInit = true;
  static final _isLoading = false;

  int _selectedIndex = 0;
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onItemTapped(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_c.hasClients) {
        _c.animateToPage(index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut);

        setState(() {
          _selectedIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));
    List<Widget> _widgetOptions = <Widget>[
      MapSample(),

    ];
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onHorizontalDragEnd: (dragEndDetails) {
          if (dragEndDetails.primaryVelocity! < 0) {
            setState(() {
              if (_selectedIndex < 3) {
                _selectedIndex = _selectedIndex + 1;
              }
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_c.hasClients) {
                _c.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              }
            });
          }

          if (dragEndDetails.primaryVelocity! > 0) {
            setState(() {
              if (_selectedIndex > 0) {
                _selectedIndex = _selectedIndex - 1;
              }
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_c.hasClients) {
                _c.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              }
            });
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: PageView.builder(
              itemCount: _widgetOptions.length,
              controller: _c,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Center(child: _widgetOptions.elementAt(index));
              }),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xfff8964f),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: const Color(0xfff8964f),
                icon: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6.0,
                  children: [
                    _selectedIndex == 0
                        ? Column(
                      children: [
                        ImageIcon(
                          Image.asset('assets/icons/home.png')
                              .image,
                          size: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(249, 60, 60, 1),
                          ),
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 12.0,
                        ),
                      ],
                    )
                        : ImageIcon(
                      Image.asset('assets/icons/home.png').image,
                      size: 20.0,
                    ),
                    _selectedIndex == 0
                        ? const Text(
                      '',
                      style: TextStyle(fontSize: 14.0),
                    )
                        : const Text(''),
                  ],
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6.0,
                  children: [
                    _selectedIndex == 1
                        ? Column(
                      children: [
                        ImageIcon(
                          Image.asset('assets/icons/image.png')
                              .image,
                          size: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(249, 60, 60, 1),
                          ),

                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 12.0,
                        ),
                      ],
                    )
                    //background: rgba(246, 220, 220, 1);
                        : ImageIcon(
                      Image.asset('assets/icons/image.png').image,
                      size: 20.0,
                    ),
                  ],
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6.0,
                  children: [
                    _selectedIndex == 2
                        ? Column(
                      children: [
                        ImageIcon(
                          Image.asset('assets/icons/Group 17.png')
                              .image,
                          size: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(249, 60, 60, 1),
                          ),
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 12.0,
                        ),
                      ],
                    )
                        : ImageIcon(
                      Image.asset('assets/icons/Group 17.png').image,
                      size: 20.0,
                    ),
                    _selectedIndex == 2
                        ? const Text(
                      '',
                      style: TextStyle(fontSize: 14.0),
                    )
                        : const Text(''),
                  ],
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6.0,
                  children: [
                    _selectedIndex == 3
                        ? Column(
                      children: [
                        ImageIcon(
                          Image.asset('assets/icons/notifications.png')
                              .image,
                          size: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(249, 60, 60, 1),
                          ),
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 12.0,
                        ),
                      ],
                    )
                        : ImageIcon(
                      Image.asset('assets/icons/notifications.png').image,
                      size: 20.0,
                    ),
                  ],
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6.0,
                  children: [
                    _selectedIndex == 4
                        ? Column(
                      children: [
                        ImageIcon(
                          Image.asset('assets/icons/person.png')
                              .image,
                          size: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(249, 60, 60, 1),
                          ),
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 12.0,
                        ),
                      ],
                    )
                        : ImageIcon(
                      Image.asset('assets/icons/person.png').image,
                      size: 20.0,
                    ),
                    _selectedIndex == 4
                        ? const Text('', style: TextStyle(fontSize: 14.0))
                        : const Text(''),
                  ],
                ),
                label: "",
              ),
            ],
            currentIndex: _selectedIndex,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(fontSize: 0.0),
            unselectedLabelStyle: const TextStyle(fontSize: 0.0),
            unselectedIconTheme:
            const IconThemeData(color: Colors.black, size: 20.0),
            selectedIconTheme: const IconThemeData(color: Colors.black),
            onTap: _onItemTapped,
          ),
        ),
      ),

    );
  }
}