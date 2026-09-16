import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 분석 화면 — 스택 카드 UI + 스크린샷 업로드
class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  // 카드 데이터
  static final _cards = <_AnalysisCardData>[
    _AnalysisCardData(
      title: '알고리즘\n오염도',
      gradient: const LinearGradient(
        colors: [Color(0xFF2EC4B6), Color(0xFF0B8A7D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      mainValue: '62',
      mainUnit: '%',
      subtitle: '정보 다양성 낮음',
      detail: '연애 콘텐츠에 62% 편향',
    ),
    _AnalysisCardData(
      title: '카테고리\n편향도',
      gradient: const LinearGradient(
        colors: [Color(0xFF5BBEDB), Color(0xFF2E7D96)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      mainValue: '6',
      mainUnit: '개',
      subtitle: '추적 중인 카테고리',
      detail: '연애/관계가 1위 (62%)',
      barData: const [
        _BarData('연애', 0.62),
        _BarData('게임', 0.45),
        _BarData('ASMR', 0.33),
        _BarData('먹방', 0.21),
        _BarData('뷰티', 0.15),
        _BarData('정치', 0.08),
      ],
    ),
    _AnalysisCardData(
      title: 'AI\n코멘트',
      gradient: const LinearGradient(
        colors: [Color(0xFF7FD48A), Color(0xFF3D8B47)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      mainValue: '3',
      mainUnit: '건',
      subtitle: '주요 피드백',
      detail: '개선 가능 항목 존재',
      comments: const [
        '연애 콘텐츠에 과도하게 노출',
        '정치/시사 카테고리 소비 극히 낮음',
        '과학/기술 분야 탐험 권장',
      ],
    ),
    _AnalysisCardData(
      title: '최근\n변화',
      gradient: const LinearGradient(
        colors: [Color(0xFF4DD0B8), Color(0xFF1A8A6E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      mainValue: '+18',
      mainUnit: '%',
      subtitle: '시청 다양성 증가',
      detail: '긍정적 변화 추세',
      changes: const [
        _ChangeData('편향도 변화', '-12%', true),
        _ChangeData('새 카테고리', '+3개', true),
        _ChangeData('시청 다양성', '+18%', true),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topPad + 16),
        // 타이틀
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text('분석', style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              )),
              const Spacer(),
              Icon(Icons.chevron_left,
                color: _currentPage > 0
                    ? AppColors.textSecondary
                    : AppColors.textTertiary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text('${_currentPage + 1}/${_cards.length}', style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                color: _currentPage < _cards.length - 1
                    ? AppColors.textSecondary
                    : AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 카드 영역
        Expanded(
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: _cards.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: _AnalysisCard(data: _cards[index]),
              );
            },
          ),
        ),

        // 페이지 인디케이터
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_cards.length, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 24 : 6,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  color: isActive ? AppColors.accentTeal : const Color(0xFFE0E0E8),
                ),
              );
            }),
          ),
        ),

        // 스크린샷 업로드 버튼
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: GestureDetector(
            onTap: () => _showUploadSheet(context),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: AppColors.brandGradient,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_photo_alternate_outlined,
                    color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text('스크린샷 업로드하여 분석', style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 60),
      ],
    );
  }


  void _showUploadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36, height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD0D0D8),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            const Text('스크린샷 업로드', style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            )),
            const SizedBox(height: 4),
            const Text('SNS 스크린샷을 업로드하면 알고리즘을 분석해드립니다',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _UploadOption(
                      icon: Icons.photo_library_outlined,
                      label: '갤러리',
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _UploadOption(
                      icon: Icons.camera_alt_outlined,
                      label: '카메라',
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
          ],
        ),
      ),
        ),
      ),
    );
  }
}

// ─── 카드 데이터 모델 ───

class _BarData {
  final String label;
  final double value;
  const _BarData(this.label, this.value);
}

class _ChangeData {
  final String label;
  final String value;
  final bool isPositive;
  const _ChangeData(this.label, this.value, this.isPositive);
}

class _AnalysisCardData {
  final String title;
  final LinearGradient gradient;
  final String mainValue;
  final String mainUnit;
  final String subtitle;
  final String detail;
  final List<_BarData>? barData;
  final List<String>? comments;
  final List<_ChangeData>? changes;
  const _AnalysisCardData({
    required this.title, required this.gradient,
    required this.mainValue, required this.mainUnit,
    required this.subtitle, required this.detail,
    this.barData, this.comments, this.changes,
  });
}

// ─── 분석 카드 위젯 ───

class _AnalysisCard extends StatelessWidget {
  final _AnalysisCardData data;
  const _AnalysisCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: data.gradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타이틀
            Text(data.title, style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.2,
            )),
            const SizedBox(height: 24),
            // 메인 수치
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(data.mainValue, style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -3,
                  height: 0.9,
                )),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(data.mainUnit, style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(data.subtitle, style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
            const SizedBox(height: 4),
            Text(data.detail, style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.5),
              fontSize: 12,
            )),
            const Spacer(),
            // 추가 콘텐츠
            if (data.barData != null) _buildBars(),
            if (data.comments != null) _buildComments(),
            if (data.changes != null) _buildChanges(),
            if (data.barData == null && data.comments == null && data.changes == null)
              _buildDefaultFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBars() {
    return Column(
      children: data.barData!.map((bar) {
        final pct = (bar.value * 100).toInt();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(width: 36, child: Text(bar.label,
                style: TextStyle(color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 12, fontWeight: FontWeight.w500))),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: bar.value,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(width: 30, child: Text('$pct%',
                style: TextStyle(color: AppColors.white.withValues(alpha: 0.7),
                  fontSize: 11, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildComments() {
    return Column(
      children: data.comments!.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(entry.value, style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 14, height: 1.4)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChanges() {
    return Column(
      children: data.changes!.map((change) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Icon(
                change.isPositive ? Icons.trending_up : Icons.trending_down,
                color: AppColors.white.withValues(alpha: 0.7),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(change.label, style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.7),
                fontSize: 14)),
              const Spacer(),
              Text(change.value, style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.9),
                fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDefaultFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('분석 요약', style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 4),
          Text('스크린샷을 업로드하여 더 정확한\n분석 결과를 확인하세요', style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.5),
            fontSize: 12,
            height: 1.4,
          )),
        ],
      ),
    );
  }
}

// ─── 업로드 옵션 위젯 ───

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _UploadOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF0EFF5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 28),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(
              color: AppColors.textPrimary, fontSize: 13,
              fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─── AnimatedBuilder (Flutter's AnimatedBuilder) ───
