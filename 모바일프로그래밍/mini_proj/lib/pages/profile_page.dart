import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 프로필 화면 — 아바타, 공유 버튼, 메뉴 리스트
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return ListView(
      padding: EdgeInsets.fromLTRB(20, topPad + 16, 20, 100),
      children: [
        // 타이틀
        const Text('프로필', style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        )),
        const SizedBox(height: 32),

        // 아바타 + 정보
        Center(
          child: Column(
            children: [
              // 아바타 — 테두리에만 그라디언트 포인트
              Container(
                width: 88,
                height: 88,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.brandGradient,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFFF0EFF5),
                    radius: 40,
                    child: Icon(Icons.person, size: 36,
                      color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('탈출자 #2847', style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
              const SizedBox(height: 4),
              const Text('알고리즘 탈출 14일째', style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              )),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // 통계 요약
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: const [
              _StatCell(value: '62', label: '오염도'),
              _StatCell(value: '-12%', label: '변화율'),
              _StatCell(value: '7', label: '새 발견'),
              _StatCell(value: '14', label: '연속일'),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 공유 버튼 — 유일한 풀컬러 요소
        GestureDetector(
          onTap: () => _showShareSheet(context),
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: AppColors.brandGradient,
            ),
            child: const Center(
              child: Text('알고리즘 정체성 공유', style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              )),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // 메뉴 리스트
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: const [
              _MenuItem(icon: Icons.tune, label: '관심사 재설정'),
              _MenuDivider(),
              _MenuItem(icon: Icons.history, label: '탈출 히스토리'),
              _MenuDivider(),
              _MenuItem(icon: Icons.bar_chart, label: '주간 리포트'),
              _MenuDivider(),
              _MenuItem(icon: Icons.notifications_outlined, label: '알림 설정'),
              _MenuDivider(),
              _MenuItem(icon: Icons.info_outline, label: '앱 정보'),
            ],
          ),
        ),
      ],
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ShareSheet(),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          )),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 12,
          )),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          )),
          const Spacer(),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
        ],
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 52),
      child: Divider(color: AppColors.separator, height: 1),
    );
  }
}

// 공유 Bottom Sheet
class _ShareSheet extends StatelessWidget {
  const _ShareSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          // 핸들
          Container(
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFD0D0D8),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text('정체성 공유하기', style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 4),
          const Text('나의 알고리즘 탈출 여정을 공유하세요', style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 13,
          )),
          const SizedBox(height: 24),
          const _ShareOption(
            icon: Icons.qr_code_2,
            label: 'QR 코드 생성',
            desc: '친구가 바로 스캔할 수 있어요',
          ),
          const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Divider(color: AppColors.separator, height: 1),
          ),
          const _ShareOption(
            icon: Icons.camera_alt_outlined,
            label: '인스타 스토리 공유',
            desc: '스토리에 카드를 공유해요',
          ),
          const Padding(
            padding: EdgeInsets.only(left: 60),
            child: Divider(color: AppColors.separator, height: 1),
          ),
          const _ShareOption(
            icon: Icons.people_outline,
            label: '앱 커뮤니티 공유',
            desc: '탈출자 커뮤니티에 게시해요',
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  const _ShareOption({required this.icon, required this.label, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                )),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
        ],
      ),
    );
  }
}
