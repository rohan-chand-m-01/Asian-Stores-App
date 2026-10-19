import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isWished;
  final VoidCallback onWish;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.isWished,
    required this.onWish,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 110,
                      color: AppColors.greenSoft,
                      child: const Center(
                        child: Icon(Icons.shopping_bag_outlined, color: AppColors.green),
                      ),
                    ),
                  ),
                ),
                if (!product.inStock)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'OUT OF STOCK',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onWish,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWished ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isWished ? Colors.red : AppColors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'PREMIUM PRODUCT',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.green,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 12, color: AppColors.gold),
                const SizedBox(width: 4),
                Text(
                  '${product.rating} (${product.reviewCount})',
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '₹${product.mrp}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${product.cashPrice}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenDark,
                  ),
                ),
              ],
            ),
            Text(
              'Cash price · ${product.packs.first.label}',
              style: const TextStyle(fontSize: 10, color: AppColors.muted),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: product.inStock ? onAdd : onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.inStock ? AppColors.green : Colors.grey[200],
                  foregroundColor: product.inStock ? Colors.white : AppColors.muted,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  product.inStock ? 'Add to Cart' : 'Notify Me',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
