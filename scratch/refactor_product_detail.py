import sys

with open('lib/features/home/presentation/pages/product_detail_page.dart', 'r') as f:
    content = f.read()

# 1. Imports
content = content.replace(
    "import 'home_page.dart';",
    "import 'package:flutter_bloc/flutter_bloc.dart';\nimport '../../../../injection_container.dart';\nimport '../bloc/home_bloc.dart';\nimport '../bloc/cart_bloc.dart';\nimport '../bloc/product_detail_bloc.dart';\nimport 'home_page.dart';"
)

# 2. Variables
content = content.replace(
    "  String _selectedSize = 'M';\n  String _selectedColor = 'White';\n  int _quantity = 1;\n  bool _isWishlisted = false;\n\n",
    ""
)

# 3. Build method
content = content.replace(
    "  @override\n  Widget build(BuildContext context) {\n    return Scaffold(",
    "  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (_) => sl<ProductDetailBloc>(),\n      child: Scaffold("
)

content = content.replace(
    "              child: _buildBottomBar(context),\n            ),\n          ],\n        ),\n      ),\n    );\n  }",
    "              child: _buildBottomBar(context),\n            ),\n          ],\n        ),\n      ),\n    ),\n    );\n  }"
)

# 4. Wishlist & Colors
content = content.replace(
    "        Padding(\n          padding: const EdgeInsets.all(8),\n          child: GestureDetector(\n            onTap: () => setState(() => _isWishlisted = !_isWishlisted),\n            child: AnimatedContainer(\n              duration: const Duration(milliseconds: 250),\n              width: 40,\n              height: 40,\n              decoration: BoxDecoration(\n                color: _isWishlisted ? Colors.red.shade50 : Colors.white,\n                borderRadius: BorderRadius.circular(12),\n                boxShadow: [\n                  BoxShadow(\n                    color: Colors.black.withValues(alpha: 0.08),\n                    blurRadius: 8,\n                  ),\n                ],\n              ),\n              child: Icon(\n                _isWishlisted\n                    ? Icons.favorite_rounded\n                    : Icons.favorite_border_rounded,\n                color: _isWishlisted ? Colors.red : Colors.grey,\n                size: 20,\n              ),\n            ),\n          ),\n        ),",
    "        BlocBuilder<HomeBloc, HomeState>(\n          builder: (context, homeState) {\n            final isWishlisted = homeState.wishlistIds.contains(widget.product.id);\n            return Padding(\n              padding: const EdgeInsets.all(8),\n              child: GestureDetector(\n                onTap: () => context.read<HomeBloc>().add(HomeWishlistToggled(widget.product.id)),\n                child: AnimatedContainer(\n                  duration: const Duration(milliseconds: 250),\n                  width: 40,\n                  height: 40,\n                  decoration: BoxDecoration(\n                    color: isWishlisted ? Colors.red.shade50 : Colors.white,\n                    borderRadius: BorderRadius.circular(12),\n                    boxShadow: [\n                      BoxShadow(\n                        color: Colors.black.withValues(alpha: 0.08),\n                        blurRadius: 8,\n                      ),\n                    ],\n                  ),\n                  child: Icon(\n                    isWishlisted\n                        ? Icons.favorite_rounded\n                        : Icons.favorite_border_rounded,\n                    color: isWishlisted ? Colors.red : Colors.grey,\n                    size: 20,\n                  ),\n                ),\n              ),\n            );\n          },\n        ),"
)

# Color dots
content = content.replace(
    "            Positioned(\n              bottom: 24,\n              left: 0,\n              right: 0,\n              child: Row(\n                mainAxisAlignment: MainAxisAlignment.center,\n                children: _colors.map((c) {\n                  final isSelected = c == _selectedColor;\n                  return GestureDetector(\n                    onTap: () => setState(() => _selectedColor = c),",
    "            Positioned(\n              bottom: 24,\n              left: 0,\n              right: 0,\n              child: BlocBuilder<ProductDetailBloc, ProductDetailState>(\n                builder: (context, state) {\n                  return Row(\n                    mainAxisAlignment: MainAxisAlignment.center,\n                    children: _colors.map((c) {\n                      final isSelected = c == state.selectedColor;\n                      return GestureDetector(\n                        onTap: () => context.read<ProductDetailBloc>().add(ProductDetailColorSelected(c)),"
)
content = content.replace(
    "                        ),\n                      ),\n                    ),\n                  );\n                }).toList(),\n              ),\n            ),",
    "                        ),\n                      ),\n                    ),\n                  );\n                }).toList(),\n                  );\n                },\n              ),\n            ),"
)

# 5. Size Selector
content = content.replace(
    "  Widget _buildSizeSelector() {\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.start,",
    "  Widget _buildSizeSelector() {\n    return BlocBuilder<ProductDetailBloc, ProductDetailState>(\n      builder: (context, state) {\n        return Column(\n          crossAxisAlignment: CrossAxisAlignment.start,"
)
content = content.replace(
    "          SingleChildScrollView(\n            scrollDirection: Axis.horizontal,\n            physics: const BouncingScrollPhysics(),\n            child: Row(\n              children: _sizes.map((size) {\n                final isSelected = size == _selectedSize;\n                return GestureDetector(\n                  onTap: () => setState(() => _selectedSize = size),",
    "          SingleChildScrollView(\n            scrollDirection: Axis.horizontal,\n            physics: const BouncingScrollPhysics(),\n            child: Row(\n              children: _sizes.map((size) {\n                final isSelected = size == state.selectedSize;\n                return GestureDetector(\n                  onTap: () => context.read<ProductDetailBloc>().add(ProductDetailSizeSelected(size)),"
)
content = content.replace(
    "                      ),\n                    ),\n                  ),\n                );\n              }).toList(),\n            ),\n          ),\n        ],\n      );\n  }",
    "                      ),\n                    ),\n                  ),\n                );\n              }).toList(),\n            ),\n          ),\n        ],\n        );\n      },\n    );\n  }"
)

# 6. Quantity Selector
content = content.replace(
    "  Widget _buildQuantitySelector() {\n    return Column(\n      crossAxisAlignment: CrossAxisAlignment.start,",
    "  Widget _buildQuantitySelector() {\n    return BlocBuilder<ProductDetailBloc, ProductDetailState>(\n      builder: (context, state) {\n        return Column(\n          crossAxisAlignment: CrossAxisAlignment.start,"
)
content = content.replace(
    "                GestureDetector(\n                  onTap: () {\n                    if (_quantity > 1) setState(() => _quantity--);\n                  },",
    "                GestureDetector(\n                  onTap: () {\n                    if (state.quantity > 1) context.read<ProductDetailBloc>().add(ProductDetailQuantityUpdated(state.quantity - 1));\n                  },"
)
content = content.replace(
    "                Padding(\n                  padding: const EdgeInsets.symmetric(horizontal: 20),\n                  child: Text(\n                    _quantity.toString(),",
    "                Padding(\n                  padding: const EdgeInsets.symmetric(horizontal: 20),\n                  child: Text(\n                    state.quantity.toString(),"
)
content = content.replace(
    "                GestureDetector(\n                  onTap: () => setState(() => _quantity++),",
    "                GestureDetector(\n                  onTap: () => context.read<ProductDetailBloc>().add(ProductDetailQuantityUpdated(state.quantity + 1)),"
)
content = content.replace(
    "                  ),\n                ),\n              ],\n            ),\n          ),\n        ],\n      );\n  }",
    "                  ),\n                ),\n              ],\n            ),\n          ),\n        ],\n        );\n      },\n    );\n  }"
)

# 7. Bottom Bar & Total Price
content = content.replace(
    "  Widget _buildBottomBar(BuildContext context) {\n    return Container(",
    "  Widget _buildBottomBar(BuildContext context) {\n    return BlocBuilder<ProductDetailBloc, ProductDetailState>(\n      builder: (context, state) {\n        return Container("
)
content = content.replace(
    "              Text(\n                _calculateTotal(),",
    "              Text(\n                _calculateTotal(state.quantity),"
)
content = content.replace(
    "            child: GestureDetector(\n              onTap: () {\n                ScaffoldMessenger.of(context).showSnackBar(",
    "            child: GestureDetector(\n              onTap: () {\n                context.read<CartBloc>().add(CartItemAdded({\n                  'product': widget.product,\n                  'quantity': state.quantity,\n                  'size': state.selectedSize,\n                  'color': state.selectedColor,\n                }));\n                ScaffoldMessenger.of(context).showSnackBar("
)
content = content.replace(
    "                    Container(\n                      padding: const EdgeInsets.all(4),\n                      decoration: BoxDecoration(\n                        color: AppColors.limeGreen,\n                        borderRadius: BorderRadius.circular(8),\n                      ),\n                      child: const Icon(\n                        Icons.arrow_forward_rounded,\n                        color: Colors.black,\n                        size: 14,\n                      ),\n                    ),\n                  ],\n                ),\n              ),\n            ),\n          ),\n        ],\n      );\n  }",
    "                    Container(\n                      padding: const EdgeInsets.all(4),\n                      decoration: BoxDecoration(\n                        color: AppColors.limeGreen,\n                        borderRadius: BorderRadius.circular(8),\n                      ),\n                      child: const Icon(\n                        Icons.arrow_forward_rounded,\n                        color: Colors.black,\n                        size: 14,\n                      ),\n                    ),\n                  ],\n                ),\n              ),\n            ),\n          ),\n        ],\n        );\n      },\n    );\n  }"
)
content = content.replace(
    "  String _calculateTotal() {\n    final rawPrice = widget.product.price.replaceAll(RegExp(r'[^\\d]'), '');\n    final price = int.tryParse(rawPrice) ?? 0;\n    final total = price * _quantity;\n    return '\\$total';\n  }",
    "  String _calculateTotal(int quantity) {\n    final rawPrice = widget.product.price.replaceAll(RegExp(r'[^\\d]'), '');\n    final price = int.tryParse(rawPrice) ?? 0;\n    final total = price * quantity;\n    return '\\$$total';\n  }"
)


with open('lib/features/home/presentation/pages/product_detail_page.dart', 'w') as f:
    f.write(content)

print("Done")
