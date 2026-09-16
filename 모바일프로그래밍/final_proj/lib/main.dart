import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const SportPickApp());
}

class SportPickApp extends StatefulWidget {
  const SportPickApp({super.key});

  @override
  State<SportPickApp> createState() => _SportPickAppState();
}

class _SportPickAppState extends State<SportPickApp> {
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sport Picker',
      themeMode: _darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF111111),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B9CFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      home: SportSelectScreen(
        darkModeEnabled: _darkModeEnabled,
        onDarkModeChanged: (value) {
          setState(() {
            _darkModeEnabled = value;
          });
        },
      ),
    );
  }
}

class Sport {
  const Sport({required this.name, required this.asset});

  final String name;
  final String asset;
}

const _sports = [
  Sport(name: '축구', asset: 'asset/sports/soccer.png'),
  Sport(name: '농구', asset: 'asset/sports/basketball.png'),
  Sport(name: '배구', asset: 'asset/sports/volleyball.png'),
  Sport(name: '야구', asset: 'asset/sports/baseball.png'),
];

class SportSelectScreen extends StatefulWidget {
  const SportSelectScreen({
    super.key,
    required this.darkModeEnabled,
    required this.onDarkModeChanged,
  });

  final bool darkModeEnabled;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<SportSelectScreen> createState() => _SportSelectScreenState();
}

class _SportSelectScreenState extends State<SportSelectScreen> {
  static const _loopSeed = 4000;
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _loopSeed,
      viewportFraction: 0.48,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openHomeScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(
          sport: _sports[_selectedIndex],
          darkModeEnabled: widget.darkModeEnabled,
          onDarkModeChanged: widget.onDarkModeChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle(context),
      child: Scaffold(
        backgroundColor: _appBackground(context),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalInset = width * 0.105;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalInset),
                    child: Text(
                      '스포츠를 즐길\n준비가 되셨나요?',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: _primaryText(context),
                            fontSize: 28,
                            height: 1.36,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.12),
                  SizedBox(
                    height: 254,
                    child: PageView.builder(
                      controller: _pageController,
                      clipBehavior: Clip.none,
                      onPageChanged: (page) {
                        setState(() {
                          _selectedIndex = page % _sports.length;
                        });
                      },
                      itemBuilder: (context, pageIndex) {
                        final sport = _sports[pageIndex % _sports.length];
                        return _SportCardPage(
                          controller: _pageController,
                          initialPage: _loopSeed,
                          pageIndex: pageIndex,
                          sport: sport,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: _PageDots(
                      count: _sports.length,
                      selectedIndex: _selectedIndex,
                    ),
                  ),
                  const SizedBox(height: 38),
                  Center(child: _SelectButton(onPressed: _openHomeScreen)),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SportCardPage extends StatelessWidget {
  const _SportCardPage({
    required this.controller,
    required this.initialPage,
    required this.pageIndex,
    required this.sport,
  });

  final PageController controller;
  final int initialPage;
  final int pageIndex;
  final Sport sport;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double page = initialPage.toDouble();
        if (controller.hasClients && controller.position.haveDimensions) {
          page = controller.page ?? page;
        }

        final distance = (page - pageIndex).abs().clamp(0.0, 1.0);
        final isActive = distance < 0.5;
        final cardSize = lerpDouble(222, 188, distance)!;
        final topOffset = lerpDouble(28, 0, distance)!;
        final blur = lerpDouble(0, 4.2, distance)!;
        final opacity = lerpDouble(1, 0.72, distance)!;

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: topOffset),
            child: Opacity(
              opacity: opacity,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                enabled: !isActive,
                child: _SportImageCard(
                  asset: sport.asset,
                  size: cardSize,
                  active: isActive,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SportImageCard extends StatelessWidget {
  const _SportImageCard({
    required this.asset,
    required this.size,
    required this.active,
  });

  final String asset;
  final double size;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: active
            ? [
                BoxShadow(
                  color: const Color(0xFFB9FFB5).withValues(alpha: 0.55),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.selectedIndex});

  final int count;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final active = index == selectedIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? _primaryText(context) : const Color(0xFFB8BDBA),
          ),
        );
      }),
    );
  }
}

class _SelectButton extends StatelessWidget {
  const _SelectButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: const Size(98, 46),
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
          backgroundColor: _raisedSurface(context),
          foregroundColor: _primaryText(context),
          textStyle: const TextStyle(
            fontSize: 16,
            height: 1,
            letterSpacing: 0,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23),
          ),
        ),
        child: const Text('선택하기'),
      ),
    );
  }
}

double _homeChromeScale(BuildContext context) {
  return 1.0;
}

bool _isDark(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color _appBackground(BuildContext context) {
  return _isDark(context) ? const Color(0xFF111111) : Colors.white;
}

Color _primaryText(BuildContext context) {
  return _isDark(context) ? const Color(0xFFF5F5F5) : const Color(0xFF202020);
}

Color _secondaryText(BuildContext context) {
  return _isDark(context) ? const Color(0xFFB8B8B8) : const Color(0xFF9F9292);
}

Color _softSurface(BuildContext context) {
  return _isDark(context) ? const Color(0xFF242424) : const Color(0xFFEDEDEF);
}

Color _raisedSurface(BuildContext context) {
  return _isDark(context) ? const Color(0xFF2C2C2C) : Colors.white;
}

SystemUiOverlayStyle _overlayStyle(BuildContext context) {
  final dark = _isDark(context);
  return (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
      .copyWith(
        statusBarColor: _appBackground(context),
        systemNavigationBarColor: _appBackground(context),
      );
}

enum HomeTab { ticket, ar, amenity }

enum MainNav { game, profile }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.sport,
    required this.darkModeEnabled,
    required this.onDarkModeChanged,
  });

  final Sport sport;
  final bool darkModeEnabled;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _homeTab = HomeTab.ticket;
  MainNav _mainNav = MainNav.game;

  @override
  Widget build(BuildContext context) {
    final chromeScale = _homeChromeScale(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle(context),
      child: Scaffold(
        backgroundColor: _appBackground(context),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: _buildContent(context)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 28 * chromeScale,
                child: _LiquidGlassNavigation(
                  scale: chromeScale,
                  selected: _mainNav,
                  onSelected: (value) {
                    setState(() {
                      _mainNav = value;
                    });
                  },
                  onSearch: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _mainNav == MainNav.profile
          ? _ProfilePane(
              key: const ValueKey('profile'),
              darkModeEnabled: widget.darkModeEnabled,
              onDarkModeChanged: widget.onDarkModeChanged,
            )
          : _GamePane(
              key: const ValueKey('game'),
              sport: widget.sport,
              selectedTab: _homeTab,
              onTabChanged: (tab) {
                setState(() {
                  _homeTab = tab;
                });
              },
            ),
    );
  }
}

class _GamePane extends StatelessWidget {
  const _GamePane({
    super.key,
    required this.sport,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final Sport sport;
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final chromeScale = _homeChromeScale(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            28 * chromeScale,
            24 * chromeScale,
            28 * chromeScale,
            0,
          ),
          child: _HomeTitleBar(scale: chromeScale),
        ),
        SizedBox(height: 24 * chromeScale),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 38 * chromeScale),
          child: _HomeSegmentedControl(
            scale: chromeScale,
            selectedTab: selectedTab,
            onChanged: onTabChanged,
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: switch (selectedTab) {
              HomeTab.ticket => const _TicketPane(key: ValueKey('ticket')),
              HomeTab.ar => const _ArPane(key: ValueKey('ar')),
              HomeTab.amenity => const _AmenityPane(key: ValueKey('amenity')),
            },
          ),
        ),
      ],
    );
  }
}

class _HomeTitleBar extends StatelessWidget {
  const _HomeTitleBar({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56 * scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24 * scale,
                    offset: Offset(0, 10 * scale),
                  ),
                ],
              ),
              child: Material(
                color: _raisedSurface(context),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: _primaryText(context),
                  iconSize: 34 * scale,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: 56 * scale,
                    height: 56 * scale,
                  ),
                  tooltip: '이전',
                ),
              ),
            ),
          ),
          Text(
            'SPORTOO',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _primaryText(context),
              fontSize: 21 * scale,
              letterSpacing: 0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSegmentedControl extends StatelessWidget {
  const _HomeSegmentedControl({
    required this.scale,
    required this.selectedTab,
    required this.onChanged,
  });

  final double scale;
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      (HomeTab.ticket, '모바일 티켓'),
      (HomeTab.ar, 'AR'),
      (HomeTab.amenity, '편의'),
    ];

    return Container(
      height: 41 * scale,
      padding: EdgeInsets.all(2 * scale),
      decoration: BoxDecoration(
        color: _softSurface(context),
        borderRadius: BorderRadius.circular(22 * scale),
        border: Border.all(
          color: _isDark(context)
              ? const Color(0xFF333333)
              : const Color(0xFFE7E7E9),
          width: 1 * scale,
        ),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(item.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedTab == item.$1
                        ? _raisedSurface(context)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20 * scale),
                    boxShadow: selectedTab == item.$1
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6 * scale,
                              offset: Offset(0, 1 * scale),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    item.$2,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _primaryText(context),
                      fontSize: 16 * scale,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w800,
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

class _TicketPane extends StatefulWidget {
  const _TicketPane({super.key});

  @override
  State<_TicketPane> createState() => _TicketPaneState();
}

class _TicketPaneState extends State<_TicketPane> {
  bool _ticketExpanded = false;

  void _setTicketExpanded(bool value) {
    setState(() {
      _ticketExpanded = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          key: const ValueKey('mobileTicket'),
          behavior: HitTestBehavior.translucent,
          onTap: () => _setTicketExpanded(true),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(30, 64, 30, 132),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'asset/home/mobile_ticket.png',
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_ticketExpanded)
          Positioned.fill(
            child: GestureDetector(
              key: const ValueKey('ticketOverlay'),
              behavior: HitTestBehavior.translucent,
              onTap: () => _setTicketExpanded(false),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: OverflowBox(
                      maxWidth: MediaQuery.sizeOf(context).width * 1.12,
                      child: Image.asset(
                        'asset/home/mobile_ticket.png',
                        width: MediaQuery.sizeOf(context).width * 1.12,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ArPane extends StatelessWidget {
  const _ArPane({super.key});

  Future<void> _openCamera() async {
    await ImagePicker().pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(38, 58, 38, 124),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '스포츠 경기 관람에 도움을 받아 보세요',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _primaryText(context),
              fontSize: 25,
              height: 1.24,
              letterSpacing: 0,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '더 편리하고 재미있게 경기를 즐길 수 있을 거예요.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _secondaryText(context),
              fontSize: 16,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 26),
          Center(
            child: Image.asset(
              'asset/home/ar_assistant.png',
              width: MediaQuery.sizeOf(context).width * 0.78,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: _SoftPillButton(
              label: 'AR 어시스턴트 사용하기',
              onPressed: _openCamera,
            ),
          ),
          const SizedBox(height: 34),
          Text(
            '어떤 기능들이 있나요?',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _primaryText(context),
              fontSize: 20,
              letterSpacing: 0,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '나의 좌석을 직관적으로 안내하고\n필드 위의 선수들을 확인할 수 있어요',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _primaryText(context),
              fontSize: 17,
              height: 1.75,
              letterSpacing: 0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            '그럼 어떻게 사용하나요?',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _primaryText(context),
              fontSize: 20,
              letterSpacing: 0,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _primaryText(context),
                fontSize: 17,
                height: 1.75,
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
              ),
              children: const [
                TextSpan(
                  text: 'AR 어시스턴트 사용하기',
                  style: TextStyle(
                    color: Color(0xFF67F36F),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: ' 버튼을 누르면\n카메라가 자동으로 실행되고\n스마트폰 화면 속으로 정보들을 볼 수 있어요',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftPillButton extends StatelessWidget {
  const _SoftPillButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 26,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: const Size(270, 74),
          padding: const EdgeInsets.symmetric(horizontal: 28),
          backgroundColor: _isDark(context)
              ? Colors.white.withValues(alpha: 0.12)
              : const Color(0xFFF9F9F9),
          foregroundColor: _primaryText(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(38),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: _primaryText(context),
            fontSize: 24,
            letterSpacing: 0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AmenityPane extends StatelessWidget {
  const _AmenityPane({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 68, 28, 124),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mapWidth = constraints.maxWidth * 0.9;

          return Column(
            children: [
              Image.asset(
                'asset/home/stadium_map_upper.png',
                width: mapWidth,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(height: 68),
              Image.asset(
                'asset/home/stadium_map_lower.png',
                width: mapWidth,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ],
          );
        },
      ),
    );
  }
}

enum ProfileTab { myPage, settings }

class _ProfilePane extends StatefulWidget {
  const _ProfilePane({
    super.key,
    required this.darkModeEnabled,
    required this.onDarkModeChanged,
  });

  final bool darkModeEnabled;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<_ProfilePane> createState() => _ProfilePaneState();
}

class _ProfilePaneState extends State<_ProfilePane> {
  ProfileTab _selectedTab = ProfileTab.myPage;
  bool _pushEnabled = true;
  bool _eventEnabled = true;
  bool _locationEnabled = true;
  late bool _darkModeEnabled;

  @override
  void initState() {
    super.initState();
    _darkModeEnabled = widget.darkModeEnabled;
  }

  @override
  void didUpdateWidget(covariant _ProfilePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.darkModeEnabled != widget.darkModeEnabled) {
      _darkModeEnabled = widget.darkModeEnabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chromeScale = _homeChromeScale(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            28 * chromeScale,
            24 * chromeScale,
            28 * chromeScale,
            0,
          ),
          child: _HomeTitleBar(scale: chromeScale),
        ),
        SizedBox(height: 24 * chromeScale),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 38 * chromeScale),
          child: _ProfileSegmentedControl(
            scale: chromeScale,
            selectedTab: _selectedTab,
            onChanged: (tab) {
              setState(() {
                _selectedTab = tab;
              });
            },
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _selectedTab == ProfileTab.myPage
                ? const _MyPageProfile(key: ValueKey('myPage'))
                : _SettingsProfile(
                    key: const ValueKey('settings'),
                    pushEnabled: _pushEnabled,
                    eventEnabled: _eventEnabled,
                    locationEnabled: _locationEnabled,
                    darkModeEnabled: _darkModeEnabled,
                    onPushChanged: (value) {
                      setState(() {
                        _pushEnabled = value;
                      });
                    },
                    onEventChanged: (value) {
                      setState(() {
                        _eventEnabled = value;
                      });
                    },
                    onLocationChanged: (value) {
                      setState(() {
                        _locationEnabled = value;
                      });
                    },
                    onDarkModeChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                      widget.onDarkModeChanged(value);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _ProfileSegmentedControl extends StatelessWidget {
  const _ProfileSegmentedControl({
    required this.scale,
    required this.selectedTab,
    required this.onChanged,
  });

  final double scale;
  final ProfileTab selectedTab;
  final ValueChanged<ProfileTab> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [(ProfileTab.myPage, '마이페이지'), (ProfileTab.settings, '설정')];

    return Container(
      height: 41 * scale,
      padding: EdgeInsets.all(2 * scale),
      decoration: BoxDecoration(
        color: _softSurface(context),
        borderRadius: BorderRadius.circular(22 * scale),
        border: Border.all(
          color: _isDark(context)
              ? const Color(0xFF333333)
              : const Color(0xFFE7E7E9),
          width: 1 * scale,
        ),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(item.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedTab == item.$1
                        ? _raisedSurface(context)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20 * scale),
                    boxShadow: selectedTab == item.$1
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6 * scale,
                              offset: Offset(0, 1 * scale),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    item.$2,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _primaryText(context),
                      fontSize: 16 * scale,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w800,
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

class _MyPageProfile extends StatelessWidget {
  const _MyPageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(30, 42, 30, 132),
      child: Column(
        children: [
          const _ProfileAvatar(),
          const SizedBox(height: 14),
          Text(
            '스포츠 사용자1',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _primaryText(context),
              fontSize: 18,
              letterSpacing: 0,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 50),
          Divider(
            height: 1,
            color: _isDark(context)
                ? const Color(0xFF333333)
                : const Color(0xFFE7E7E7),
          ),
          const SizedBox(height: 18),
          const _ProfileMenuItem(label: '내 정보'),
          const _ProfileMenuItem(label: '내 리뷰'),
          const _ProfileMenuItem(label: '문의하기'),
          const _ProfileMenuItem(label: '서비스 이용약관'),
          const _ProfileMenuItem(label: '개인정보 이용약관'),
          const _ProfileMenuItem(label: '로그아웃'),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      height: 104,
      child: CustomPaint(painter: _ProfileAvatarPainter()),
    );
  }
}

class _ProfileAvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outline = Paint()
      ..color = const Color(0xFFB8B8B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;
    final fill = Paint()
      ..color = const Color(0xFFB8B8B8)
      ..style = PaintingStyle.fill;

    canvas
      ..drawCircle(center, size.width * 0.41, outline)
      ..drawCircle(
        Offset(center.dx, size.height * 0.35),
        size.width * 0.16,
        fill,
      );

    final body = Path()
      ..moveTo(size.width * 0.18, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.55,
        size.width * 0.82,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        size.width * 0.67,
        size.height * 0.91,
        size.width * 0.5,
        size.height * 0.91,
      )
      ..quadraticBezierTo(
        size.width * 0.33,
        size.height * 0.91,
        size.width * 0.18,
        size.height * 0.78,
      );
    canvas.drawPath(body, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _primaryText(context),
            fontSize: 17,
            letterSpacing: 0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SettingsProfile extends StatelessWidget {
  const _SettingsProfile({
    super.key,
    required this.pushEnabled,
    required this.eventEnabled,
    required this.locationEnabled,
    required this.darkModeEnabled,
    required this.onPushChanged,
    required this.onEventChanged,
    required this.onLocationChanged,
    required this.onDarkModeChanged,
  });

  final bool pushEnabled;
  final bool eventEnabled;
  final bool locationEnabled;
  final bool darkModeEnabled;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEventChanged;
  final ValueChanged<bool> onLocationChanged;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(30, 58, 30, 132),
      child: Column(
        children: [
          Divider(
            height: 1,
            color: _isDark(context)
                ? const Color(0xFF333333)
                : const Color(0xFFE7E7E7),
          ),
          const SizedBox(height: 16),
          _SettingsRow(
            label: '푸시 알림 설정',
            trailing: _ProfileSwitch(
              value: pushEnabled,
              onChanged: onPushChanged,
            ),
          ),
          _SettingsRow(
            label: '경기 시작 전 알림',
            trailing: Text('30분 전', style: _settingsValueStyle(context)),
          ),
          _SettingsRow(
            label: '이벤트 알림',
            trailing: _ProfileSwitch(
              value: eventEnabled,
              onChanged: onEventChanged,
            ),
          ),
          _SettingsRow(
            label: '기본 스포츠',
            trailing: Text('축구', style: _settingsValueStyle(context)),
          ),
          _SettingsRow(
            label: '기본 경기장',
            trailing: Text('서울월드컵경기장', style: _settingsValueStyle(context)),
          ),
          _SettingsRow(
            label: '위치 정보 사용',
            trailing: _ProfileSwitch(
              value: locationEnabled,
              onChanged: onLocationChanged,
            ),
          ),
          _SettingsRow(
            label: '다크모드',
            trailing: _ProfileSwitch(
              value: darkModeEnabled,
              onChanged: onDarkModeChanged,
            ),
          ),
          const SizedBox(height: 44),
          _SettingsRow(
            label: '앱 버전',
            trailing: Text('1.0.0', style: _settingsValueStyle(context)),
          ),
        ],
      ),
    );
  }

  TextStyle? _settingsValueStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(
      color: _isDark(context)
          ? const Color(0xFFB8B8B8)
          : const Color(0xFF7B7B7B),
      fontSize: 17,
      letterSpacing: 0,
      fontWeight: FontWeight.w700,
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.trailing});

  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _primaryText(context),
                fontSize: 17,
                letterSpacing: 0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _ProfileSwitch extends StatelessWidget {
  const _ProfileSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.9,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: const Color(0xFF5EC76B),
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: const Color(0xFFC8C9CC),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}

class _LiquidGlassNavigation extends StatelessWidget {
  const _LiquidGlassNavigation({
    required this.scale,
    required this.selected,
    required this.onSelected,
    required this.onSearch,
  });

  final double scale;
  final MainNav selected;
  final ValueChanged<MainNav> onSelected;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30 * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _GlassPill(
            scale: scale,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _GlassNavItem(
                  scale: scale,
                  icon: Icons.sports_soccer,
                  label: '경기',
                  active: selected == MainNav.game,
                  onTap: () => onSelected(MainNav.game),
                ),
                SizedBox(width: 2 * scale),
                _GlassNavItem(
                  scale: scale,
                  icon: Icons.circle,
                  label: '프로필',
                  active: selected == MainNav.profile,
                  onTap: () => onSelected(MainNav.profile),
                ),
              ],
            ),
          ),
          const Spacer(),
          _GlassRoundButton(
            scale: scale,
            icon: Icons.search_rounded,
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.scale, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25 * scale),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18 * scale, sigmaY: 18 * scale),
        child: Container(
          height: 62 * scale,
          padding: EdgeInsets.all(5 * scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25 * scale),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.64),
                Colors.white.withValues(alpha: 0.36),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.72),
              width: 0.8 * scale,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 28 * scale,
                offset: Offset(0, 12 * scale),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassNavItem extends StatelessWidget {
  const _GlassNavItem({
    required this.scale,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final double scale;
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = active
        ? const Color(0xFF4B9CFF)
        : _primaryText(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 88 * scale,
        height: 52 * scale,
        decoration: BoxDecoration(
          color: active
              ? Colors.white.withValues(alpha: 0.56)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(21 * scale),
          border: active
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.9),
                  width: 0.8 * scale,
                )
              : null,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.45),
                    blurRadius: 12 * scale,
                    offset: Offset(-2 * scale, -2 * scale),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16 * scale,
                    offset: Offset(0, 8 * scale),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 25 * scale, color: activeColor),
            SizedBox(height: 3 * scale),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: activeColor,
                fontSize: 10 * scale,
                height: 1,
                letterSpacing: 0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassRoundButton extends StatelessWidget {
  const _GlassRoundButton({
    required this.scale,
    required this.icon,
    required this.onPressed,
  });

  final double scale;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18 * scale, sigmaY: 18 * scale),
        child: Material(
          color: Colors.white.withValues(alpha: 0.48),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            child: Ink(
              width: 62 * scale,
              height: 62 * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.76),
                  width: 0.8 * scale,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 28 * scale,
                    offset: Offset(0, 12 * scale),
                  ),
                ],
              ),
              child: Icon(icon, color: _primaryText(context), size: 32 * scale),
            ),
          ),
        ),
      ),
    );
  }
}
