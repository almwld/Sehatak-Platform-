import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/payment/yemen_wallet_service.dart';
import '../../../core/services/payment/stripe_payment_service.dart';
import '../../../core/models/payment/payment_model.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String orderId;
  final String description;

  const PaymentScreen({
    Key? key,
    required this.amount,
    required this.orderId,
    required this.description,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'wallet';
  String _selectedWallet = 'national';
  String _phoneNumber = '';
  bool _isLoading = false;

  final YemenWalletService _walletService = YemenWalletService();
  final StripePaymentService _stripeService = StripePaymentService();

  // 🏦 قائمة المحافظ اليمنية
  final List<WalletOption> _walletOptions = [
    WalletOption(id: 'national', name: 'المحفظة الوطنية', icon: '🇾🇪'),
    WalletOption(id: 'floosak', name: 'فلوسك - بنك اليمن والكويت', icon: '💳'),
    WalletOption(id: 'jawali', name: 'جوالي - يمن موبايل', icon: '📱'),
    WalletOption(id: 'jib', name: 'جيب', icon: '👛'),
    WalletOption(id: 'easycash', name: 'إيزي كاش', icon: '🏧'),
    WalletOption(id: 'cash', name: 'كاش', icon: '💰'),
    WalletOption(id: 'yemenwallet', name: 'يمن واليت', icon: '💚'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدفع'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📊 ملخص الطلب
            _buildOrderSummary(),
            const SizedBox(height: 24),

            // 💳 طرق الدفع
            _buildPaymentMethods(),
            const SizedBox(height: 24),

            // 🏦 اختيار المحفظة (إذا كانت المحفظة مختارة)
            if (_selectedMethod == 'wallet')
              _buildWalletSelection(),
            const SizedBox(height: 24),

            // 📱 إدخال رقم الهاتف
            if (_selectedMethod == 'wallet')
              _buildPhoneInput(),
            const SizedBox(height: 32),

            // 🔘 زر الدفع
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الطلب',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.description,
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                '${widget.amount.toStringAsFixed(0)} ريال',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.amount.toStringAsFixed(0)} ريال',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'طريقة الدفع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMethodOption(
                id: 'wallet',
                icon: Icons.phone_android,
                label: 'محفظة إلكترونية',
                selected: _selectedMethod == 'wallet',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMethodOption(
                id: 'card',
                icon: Icons.credit_card,
                label: 'بطاقة بنكية',
                selected: _selectedMethod == 'card',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodOption({
    required String id,
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.green : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? Colors.green : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.green : Colors.grey[600],
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر المحفظة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _walletOptions.map((wallet) {
            return FilterChip(
              label: Text(wallet.name),
              selected: _selectedWallet == wallet.id,
              onSelected: (selected) {
                setState(() {
                  _selectedWallet = wallet.id;
                });
              },
              selectedColor: Colors.green.shade100,
              backgroundColor: Colors.grey[50],
              labelStyle: TextStyle(
                color: _selectedWallet == wallet.id ? Colors.green : Colors.black,
              ),
              avatar: Text(wallet.icon),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'رقم الهاتف المرتبط بالمحفظة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'مثال: 777123456',
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            _phoneNumber = value;
          },
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'دفع الآن',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // 🚀 معالجة الدفع
  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      PaymentResult result;

      if (_selectedMethod == 'wallet') {
        // الدفع عبر المحفظة الإلكترونية
        result = await _processWalletPayment();
      } else {
        // الدفع عبر البطاقة البنكية
        result = await _processCardPayment();
      }

      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        // ✅ نجاح الدفع
        _showPaymentSuccess(result);
      } else {
        // ❌ فشل الدفع
        _showPaymentError(result.message);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showPaymentError('حدث خطأ غير متوقع');
    }
  }

  Future<PaymentResult> _processWalletPayment() async {
    switch (_selectedWallet) {
      case 'national':
        return await _walletService.payWithNationalWallet(
          phoneNumber: _phoneNumber,
          amount: widget.amount,
          orderId: widget.orderId,
          description: widget.description,
        );
      case 'floosak':
        return await _walletService.payWithFloosak(
          phoneNumber: _phoneNumber,
          amount: widget.amount,
          orderId: widget.orderId,
        );
      case 'jawali':
        // return await _walletService.payWithJawali(...);
        // للتبسيط
        return PaymentResult(
          success: false,
          message: 'خدمة جوالي قيد التطوير',
        );
      default:
        return PaymentResult(
          success: false,
          message: 'المحفظة غير مدعومة حالياً',
        );
    }
  }

  Future<PaymentResult> _processCardPayment() async {
    // هنا يمكن عرض واجهة لإدخال بيانات البطاقة
    // أو استخدام Payment Sheet من Stripe
    return PaymentResult(
      success: false,
      message: 'خدمة البطاقات البنكية قيد التطوير',
    );
  }

  void _showPaymentSuccess(PaymentResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('تم الدفع بنجاح!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('شكراً لاستخدامك منصة صحتك'),
            const SizedBox(height: 8),
            if (result.transactionId != null)
              Text(
                'رقم العملية: ${result.transactionId}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true); // عودة مع نجاح
            },
            child: const Text('تم'),
          ),
        ],
      ),
    );
  }

  void _showPaymentError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('فشل الدفع'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حاول مرة أخرى'),
          ),
        ],
      ),
    );
  }
}

class WalletOption {
  final String id;
  final String name;
  final String icon;

  WalletOption({
    required this.id,
    required this.name,
    required this.icon,
  });
}
