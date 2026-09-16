import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'explore_detail_page.dart';

/// 홈 화면 — 2-Tab 레이아웃 (인사이트 / 탐험)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topPad + 16),
        // 타이틀
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('홈', style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          )),
        ),
        const SizedBox(height: 16),
        // 탭 바
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceTertiary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TabBar(
              controller: _tabCtrl,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              dividerColor: Colors.transparent,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textTertiary,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              tabs: const [
                Tab(text: '인사이트'),
                Tab(text: '탐험'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 탭 콘텐츠
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: const [
              _InsightsTab(),
              _ExploreTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Tab 1: 인사이트 — 그래프/차트 기반 직관적 표현
// ──────────────────────────────────────────────

class _InsightsTab extends StatelessWidget {
  const _InsightsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        // 알고리즘 요약 — 도넛 차트
        _InsightCard(
          title: '나의 알고리즘 요약',
          child: Column(
            children: [
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: Center(
                  child: _DonutChart(
                    data: const [
                      _ChartSegment('연애/관계', 0.62, Color(0xFF2EC4B6)),
                      _ChartSegment('게임', 0.45, Color(0xFF7FD48A)),
                      _ChartSegment('ASMR', 0.33, Color(0xFF5BBEDB)),
                      _ChartSegment('먹방/요리', 0.21, Color(0xFFA8E06C)),
                      _ChartSegment('뷰티', 0.15, Color(0xFF4DD0B8)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 범례
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: const [
                  _LegendItem(color: Color(0xFF2EC4B6), label: '연애/관계', pct: '35%'),
                  _LegendItem(color: Color(0xFF7FD48A), label: '게임', pct: '26%'),
                  _LegendItem(color: Color(0xFF5BBEDB), label: 'ASMR', pct: '19%'),
                  _LegendItem(color: Color(0xFFA8E06C), label: '먹방/요리', pct: '12%'),
                  _LegendItem(color: Color(0xFF4DD0B8), label: '뷰티', pct: '8%'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 연령별 분포 — 수평 바 차트
        _InsightCard(
          title: '연령별 알고리즘 분포',
          child: Column(
            children: const [
              SizedBox(height: 8),
              _HorizontalBar(label: '10대', value: 0.72, color: Color(0xFF2EC4B6), detail: '엔터테인먼트'),
              SizedBox(height: 14),
              _HorizontalBar(label: '20대', value: 0.58, color: Color(0xFF7FD48A), detail: '라이프스타일'),
              SizedBox(height: 14),
              _HorizontalBar(label: '30대', value: 0.45, color: Color(0xFF5BBEDB), detail: '정보/뉴스'),
              SizedBox(height: 14),
              _HorizontalBar(label: '40대+', value: 0.61, color: Color(0xFF4DD0B8), detail: '뉴스/건강'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 성별 분포 — 비교 바 차트
        _InsightCard(
          title: '성별 콘텐츠 편향',
          child: Column(
            children: const [
              SizedBox(height: 8),
              _GenderCompareBar(
                label1: '남성', value1: 0.51, detail1: '게임/스포츠',
                label2: '여성', value2: 0.48, detail2: '뷰티/라이프',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 일일 사용 시간
        _InsightCard(
          title: '일일 평균 사용 시간',
          child: Column(
            children: const [
              SizedBox(height: 8),
              _HorizontalBar(label: '월', value: 0.45, color: Color(0xFF2EC4B6), detail: '2.7시간'),
              SizedBox(height: 10),
              _HorizontalBar(label: '화', value: 0.62, color: Color(0xFF2EC4B6), detail: '3.7시간'),
              SizedBox(height: 10),
              _HorizontalBar(label: '수', value: 0.38, color: Color(0xFF7FD48A), detail: '2.3시간'),
              SizedBox(height: 10),
              _HorizontalBar(label: '목', value: 0.55, color: Color(0xFF2EC4B6), detail: '3.3시간'),
              SizedBox(height: 10),
              _HorizontalBar(label: '금', value: 0.78, color: Color(0xFF5BBEDB), detail: '4.7시간'),
              SizedBox(height: 10),
              _HorizontalBar(label: '토', value: 0.92, color: Color(0xFF5BBEDB), detail: '5.5시간'),
              SizedBox(height: 10),
              _HorizontalBar(label: '일', value: 0.85, color: Color(0xFF5BBEDB), detail: '5.1시간'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 주간 변화
        _InsightCard(
          title: '주간 알고리즘 변화',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              _TrendRow(label: '편향도 변화', value: '-12%', isPositive: true),
              const Divider(color: AppColors.separator, height: 20),
              _TrendRow(label: '새 카테고리 발견', value: '+3개', isPositive: true),
              const Divider(color: AppColors.separator, height: 20),
              _TrendRow(label: '평균 시청 다양성', value: '+18%', isPositive: true),
              const Divider(color: AppColors.separator, height: 20),
              _TrendRow(label: '반복 콘텐츠 비율', value: '-8%', isPositive: true),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 인기 키워드
        _InsightCard(
          title: '나의 TOP 키워드',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _KeywordChip(label: '#연애', rank: 1),
              _KeywordChip(label: '#게임리뷰', rank: 2),
              _KeywordChip(label: '#ASMR', rank: 3),
              _KeywordChip(label: '#먹방', rank: 4),
              _KeywordChip(label: '#뷰티팁', rank: 5),
              _KeywordChip(label: '#일상브이로그', rank: 6),
              _KeywordChip(label: '#자기계발', rank: 7),
              _KeywordChip(label: '#운동루틴', rank: 8),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 콘텐츠 다양성 지수
        _InsightCard(
          title: '콘텐츠 다양성 지수',
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
                          child: const Text('38점', style: TextStyle(
                            color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 4),
                        const Text('100점 만점', style: TextStyle(
                          color: AppColors.textTertiary, fontSize: 12)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _MiniStat(label: '탐색한 분야', value: '3/12'),
                        SizedBox(height: 8),
                        _MiniStat(label: '새 콘텐츠 비율', value: '12%'),
                        SizedBox(height: 8),
                        _MiniStat(label: '반복 시청률', value: '73%'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── 도넛 차트 ───

class _ChartSegment {
  final String label;
  final double value;
  final Color color;
  const _ChartSegment(this.label, this.value, this.color);
}

class _DonutChart extends StatelessWidget {
  final List<_ChartSegment> data;
  const _DonutChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: CustomPaint(
        painter: _DonutPainter(data),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.brandGradient.createShader(bounds),
                child: const Text('62%', style: TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                )),
              ),
              const Text('편향도', style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<_ChartSegment> segments;
  _DonutPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 26.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    // 배경
    final bgPaint = Paint()
      ..color = const Color(0xFFE8E7EF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // 세그먼트
    final total = segments.fold<double>(0, (sum, s) => sum + s.value);
    double startAngle = -math.pi / 2;
    for (final seg in segments) {
      final sweepAngle = (seg.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle - 0.06, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;
  const _LegendItem({required this.color, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text('$label $pct', style: const TextStyle(
          color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}

// ─── 수평 바 차트 ───

class _HorizontalBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String detail;
  const _HorizontalBar({
    required this.label, required this.value,
    required this.color, required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(label, style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Stack(
                children: [
                   Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E7EF),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                   FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 6),
                      child: Text('$pct%', style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 70,
              child: Text(detail, style: const TextStyle(
                color: AppColors.textTertiary, fontSize: 11),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── 성별 비교 바 ───

class _GenderCompareBar extends StatelessWidget {
  final String label1, detail1;
  final double value1;
  final String label2, detail2;
  final double value2;
  const _GenderCompareBar({
    required this.label1, required this.value1, required this.detail1,
    required this.label2, required this.value2, required this.detail2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 남성
        _GenderRow(label: label1, value: value1, detail: detail1,
            color: AppColors.accentTeal),
        const SizedBox(height: 16),
        // vs divider
        Row(
          children: [
            Expanded(child: Container(height: 0.5, color: AppColors.separator)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('VS', style: TextStyle(
                color: AppColors.textTertiary, fontSize: 11,
                fontWeight: FontWeight.w700, letterSpacing: 2)),
            ),
            Expanded(child: Container(height: 0.5, color: AppColors.separator)),
          ],
        ),
        const SizedBox(height: 16),
        // 여성
        _GenderRow(label: label2, value: value2, detail: detail2,
            color: AppColors.accentGreen),
      ],
    );
  }
}

class _GenderRow extends StatelessWidget {
  final String label;
  final double value;
  final String detail;
  final Color color;
  const _GenderRow({required this.label, required this.value,
    required this.detail, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).toInt();
    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(label, style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(detail, style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
                  const Spacer(),
                  Text('$pct%', style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E7EF),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _InsightCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// 추가 인사이트 위젯
// ──────────────────────────────────────────────

class _TrendRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;
  const _TrendRow({required this.label, required this.value, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? AppColors.accentGreen : const Color(0xFFFF453A),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(
          color: AppColors.textSecondary, fontSize: 14)),
        const Spacer(),
        Text(value, style: TextStyle(
          color: isPositive ? AppColors.accentGreen : const Color(0xFFFF453A),
          fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String label;
  final int rank;
  const _KeywordChip({required this.label, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isTop = rank <= 3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isTop ? AppColors.accentTeal.withValues(alpha: 0.12) : const Color(0xFFE8E7EF),
        borderRadius: BorderRadius.circular(20),
        border: isTop ? Border.all(color: AppColors.accentTeal.withValues(alpha: 0.3)) : null,
      ),
      child: Text(label, style: TextStyle(
        color: isTop ? AppColors.accentTeal : AppColors.textSecondary,
        fontSize: 13, fontWeight: isTop ? FontWeight.w600 : FontWeight.w400)),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(
          color: AppColors.textTertiary, fontSize: 12)),
        const Spacer(),
        Text(value, style: const TextStyle(
          color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Tab 2: 탐험 — Pinterest 스타일 Masonry Grid
// ──────────────────────────────────────────────

class _ExploreItem {
  final String id;
  final String title;
  final String category;
  final String desc;
  final Color color;
  final double aspectRatio;
  final IconData icon;
  final double difference; // 0.0~1.0 알고리즘 차이도
  const _ExploreItem({
    required this.id, required this.title, required this.category,
    required this.desc, required this.color, required this.aspectRatio,
    required this.icon, required this.difference,
  });
}

const _exploreItems = [
  _ExploreItem(id: 'e1', title: '조선시대 궁궐 건축의 비밀',
    category: '역사', desc: '경복궁의 숨겨진 수학적 비율과 풍수지리 이야기',
    color: Color(0xFF2C3E50), aspectRatio: 1.3, icon: Icons.account_balance, difference: 0.85),
  _ExploreItem(id: 'e2', title: '발효 과학: 김치의 미생물학',
    category: '과학', desc: '유산균이 만들어내는 맛의 교향곡',
    color: Color(0xFF1B5E20), aspectRatio: 0.85, icon: Icons.science, difference: 0.72),
  _ExploreItem(id: 'e3', title: '심해 탐험: 마리아나 해구',
    category: '자연', desc: '빛이 닿지 않는 곳의 생명체들',
    color: Color(0xFF0D47A1), aspectRatio: 1.0, icon: Icons.water, difference: 0.91),
  _ExploreItem(id: 'e4', title: '양자 컴퓨팅 입문',
    category: '기술', desc: '큐비트부터 양자 얽힘까지',
    color: Color(0xFF4A148C), aspectRatio: 1.4, icon: Icons.memory, difference: 0.65),
  _ExploreItem(id: 'e5', title: '아프리카 부족의 음악 치료',
    category: '문화', desc: '전통 리듬 치료법의 과학적 근거',
    color: Color(0xFFBF360C), aspectRatio: 0.9, icon: Icons.music_note, difference: 0.78),
  _ExploreItem(id: 'e6', title: '우주 정거장의 일상',
    category: '우주', desc: 'ISS에서 보내는 하루의 모든 것',
    color: Color(0xFF263238), aspectRatio: 1.1, icon: Icons.rocket_launch, difference: 0.88),
  _ExploreItem(id: 'e7', title: '인공지능과 예술의 경계',
    category: '기술', desc: 'AI가 그린 그림은 예술인가?',
    color: Color(0xFF311B92), aspectRatio: 1.15, icon: Icons.palette, difference: 0.55),
  _ExploreItem(id: 'e8', title: '북극 빙하의 비밀 생태계',
    category: '자연', desc: '녹아가는 빙하 속 미생물 세계',
    color: Color(0xFF006064), aspectRatio: 0.95, icon: Icons.ac_unit, difference: 0.82),
  _ExploreItem(id: 'e9', title: '고대 이집트 피라미드',
    category: '역사', desc: '4500년 된 건축 기술의 비밀',
    color: Color(0xFF795548), aspectRatio: 1.25, icon: Icons.landscape, difference: 0.93),
  _ExploreItem(id: 'e10', title: '명상과 뇌과학',
    category: '건강', desc: '명상이 뇌 구조를 바꾸는 증거',
    color: Color(0xFF1A237E), aspectRatio: 0.8, icon: Icons.self_improvement, difference: 0.60),
  _ExploreItem(id: 'e11', title: '세계의 독특한 축제들',
    category: '문화', desc: '토마토 축제부터 빛 축제까지',
    color: Color(0xFFE65100), aspectRatio: 1.1, icon: Icons.celebration, difference: 0.74),
  _ExploreItem(id: 'e12', title: '블록체인과 미래 금융',
    category: '경제', desc: '탈중앙화 금융의 가능성과 위험',
    color: Color(0xFF37474F), aspectRatio: 1.35, icon: Icons.currency_bitcoin, difference: 0.68),
];

class _ExploreTab extends StatelessWidget {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const hPadding = 20.0;
        const gap = 10.0;
        final columnWidth = (constraints.maxWidth - hPadding * 2 - gap) / 2;

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: hPadding),
              sliver: SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: columnWidth,
                      child: _buildColumn(context, 0, columnWidth),
                    ),
                    const SizedBox(width: gap),
                    SizedBox(
                      width: columnWidth,
                      child: _buildColumn(context, 1, columnWidth),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }

  Widget _buildColumn(BuildContext context, int col, double width) {
    final items = <_ExploreItem>[];
    for (int i = col; i < _exploreItems.length; i += 2) {
      items.add(_exploreItems[i]);
    }
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _ExploreCard(item: item, width: width),
        );
      }).toList(),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final _ExploreItem item;
  final double width;
  const _ExploreCard({required this.item, required this.width});

  @override
  Widget build(BuildContext context) {
    final height = width * item.aspectRatio;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ExploreDetailPage(
              id: item.id, title: item.title, category: item.category,
              desc: item.desc, color: item.color, icon: item.icon,
            ),
            transitionsBuilder: (context, anim, secondaryAnimation, child) {
              return FadeTransition(opacity: anim, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: Hero(
        tag: 'explore_${item.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // 아이콘 배경
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(item.icon, size: 70,
                    color: AppColors.white.withValues(alpha: 0.06)),
                ),
                // 콘텐츠
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 알고리즘 차이도 게이지
                      Row(
                        children: [
                          Icon(Icons.shuffle, size: 10,
                            color: AppColors.white.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text('${(item.difference * 100).toInt()}%', style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 9, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(1.5),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: item.difference,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.brandGradient,
                                      borderRadius: BorderRadius.circular(1.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(item.category, style: const TextStyle(
                          color: AppColors.white, fontSize: 10,
                          fontWeight: FontWeight.w500)),
                      ),
                      const Spacer(),
                      Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white, fontSize: 14,
                          fontWeight: FontWeight.w600, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
