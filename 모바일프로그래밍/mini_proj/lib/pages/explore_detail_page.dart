import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 탐험 상세 페이지 — Hero 전환으로 이미지 확대
class ExploreDetailPage extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String desc;
  final Color color;
  final IconData icon;

  const ExploreDetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.desc,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Hero 이미지 영역 — 전체 폭으로 확대
          Hero(
            tag: 'explore_$id',
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                height: 340,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    // 배경 아이콘
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(icon, size: 200,
                        color: AppColors.white.withValues(alpha: 0.05)),
                    ),
                    // 뒤로가기
                    Positioned(
                      top: topPad + 8,
                      left: 8,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new,
                          color: AppColors.white, size: 20),
                      ),
                    ),
                    // 카테고리
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(category, style: const TextStyle(
                          color: AppColors.white, fontSize: 13,
                          fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 콘텐츠 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  )),
                  const SizedBox(height: 12),
                  Text(desc, style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    height: 1.6,
                  )),
                  const SizedBox(height: 24),
                  // 더미 본문
                  Text(
                    '이 콘텐츠는 당신의 평소 알고리즘과 완전히 다른 '
                    '카테고리에서 선별되었습니다. 새로운 관점을 발견하고, '
                    '에코 챔버를 벗어나 보세요.\n\n'
                    '알고리즘이 추천하지 않았을 이 주제를 통해 '
                    '정보의 다양성을 경험할 수 있습니다. '
                    '매일 하나씩 새로운 세계를 만나보세요.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 액션 버튼
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                          ),
                          child: const Center(
                            child: Text('저장하기', style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: AppColors.brandGradient,
                          ),
                          child: const Center(
                            child: Text('탐험하기', style: TextStyle(
                              color: Colors.white,
                              fontSize: 15, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
