import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart';

/// Accordion (dropdown) yang menampilkan detail produk: Description,
/// Size & Fit, Materials, Shipping & Returns.
/// State expand/collapse dikelola secara lokal (UI-only, bukan BLoC).
class ProductAccordion extends StatefulWidget {
  /// Map berisi judul → konten accordion.
  final Map<String, String> details;

  const ProductAccordion({super.key, required this.details});

  @override
  State<ProductAccordion> createState() => _ProductAccordionState();
}

class _ProductAccordionState extends State<ProductAccordion> {
  late final Map<String, bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = {
      for (final key in widget.details.keys) key: key == 'Description',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: widget.details.entries.map((entry) {
          return _AccordionItem(
            title: entry.key,
            content: entry.value,
            isOpen: _expanded[entry.key] ?? false,
            onToggle: () =>
                setState(() => _expanded[entry.key] = !_expanded[entry.key]!),
          );
        }).toList(),
      ),
    );
  }
}

class _AccordionItem extends StatelessWidget {
  final String title;
  final String content;
  final bool isOpen;
  final VoidCallback onToggle;

  const _AccordionItem({
    required this.title,
    required this.content,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            GestureDetector(
              onTap: onToggle,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    _accordionIcon(title),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isOpen
                              ? AppColors.limeGreen
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color:
                              isOpen ? Colors.black : Colors.grey.shade500,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.easeOutCubic,
              secondCurve: Curves.easeInCubic,
              crossFadeState: isOpen
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Colors.grey.shade100, thickness: 1),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accordionIcon(String title) {
    IconData icon;
    Color color;
    switch (title) {
      case 'Description':
        icon = Icons.info_outline_rounded;
        color = AppColors.cobaltBlue;
        break;
      case 'Size & Fit':
        icon = Icons.straighten_rounded;
        color = Colors.purple;
        break;
      case 'Materials':
        icon = Icons.eco_outlined;
        color = Colors.green;
        break;
      case 'Shipping & Returns':
        icon = Icons.local_shipping_outlined;
        color = Colors.orange;
        break;
      default:
        icon = Icons.help_outline_rounded;
        color = Colors.grey;
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: color, size: 17),
    );
  }
}
