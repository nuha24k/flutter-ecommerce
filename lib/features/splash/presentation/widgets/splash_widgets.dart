import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

/// Badge kecil "Holiday Market"
class HolidayMarketBadge extends StatelessWidget {
  const HolidayMarketBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
        borderRadius: BorderRadius.circular(100),
        color: Colors.white.withValues(alpha: 0.12),
      ),
      child: const Text('Holiday Market', style: AppTextStyles.badge),
    );
  }
}

/// Bento Grid Layout — tiga sel foto fashion.
///
/// Layout:
/// ┌────────────┬──────────┐
/// │            │  Model 2 │
/// │  Model 1   ├──────────┤
/// │  (tall)    │   Tag    │
/// └────────────┴──────────┘
class BentoPhotoGrid extends StatelessWidget {
  const BentoPhotoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 340,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Sel kiri: Model jaket (tinggi penuh) ──
          Expanded(
            flex: 55,
            child: _BentoCell(
              imagePath: 'assets/images/model_jacket.png',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          const SizedBox(width: 6),

          // ── Kolom kanan: dua sel bertumpuk ──
          Expanded(
            flex: 45,
            child: Column(
              children: [
                // Sel kanan atas: Model kaos
                Expanded(
                  flex: 55,
                  child: _BentoCell(
                    imagePath: 'assets/images/model_tshirt.png',
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(28),
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                const SizedBox(height: 6),

                // Sel kanan bawah: Tag / Brand card
                Expanded(
                  flex: 45,
                  child: _BentoCell(
                    imagePath: 'assets/images/bento_tag.png',
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(28),
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sel individual bento dengan konfigurasi sudut
class _BentoCell extends StatelessWidget {
  const _BentoCell({
    required this.imagePath,
    required this.borderRadius,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final String imagePath;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        child: Image.asset(
          imagePath,
          fit: fit,
          alignment: alignment,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

/// Tombol "Get Started" — lime green, lebar penuh
class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.limeGreen,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: AppColors.limeGreen.withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Get Started', style: AppTextStyles.buttonLabel),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.limeGreen,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
