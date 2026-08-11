import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class PaymentMethodCard extends StatelessWidget {
  final List<String> paymentMethods;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethods,
  });

  IconData _getIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.payments_rounded;
      case 'qris':
        return Icons.qr_code_2_rounded;
      case 'gopay':
      case 'dana':
      case 'ovo':
      case 'shopeepay':
        return Icons.account_balance_wallet_rounded;
      case 'bca':
      case 'bni':
      case 'bri':
      case 'mandiri':
        return Icons.credit_card_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: const [

              Icon(
                Icons.payments_rounded,
                color: AppColor.primary,
              ),

              SizedBox(width: 10),

              Text(
                "Metode Pembayaran",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: paymentMethods.map((method) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Icon(
                      _getIcon(method),
                      color: AppColor.primary,
                      size: 20,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      method,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  ],
                ),
              );
            }).toList(),
          ),

        ],
      ),
    );
  }
}