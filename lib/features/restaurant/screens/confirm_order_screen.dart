import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/profile/settings/screens/add_new_location_screen.dart';
import 'package:fooddeliveryapp/features/profile/settings/screens/payment_method_screen.dart';
import 'package:fooddeliveryapp/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/location_providers.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key});
  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen>
    with WidgetsBindingObserver {
  double _voucherDiscount = 0.0;
  bool _isLoading = false;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _selectedLocation;
  List<Map<String, dynamic>> _savedLocations = [];
  bool _isFetchingLocations = true;
  String _selectedPaymentMethod = '';
  List<Map<String, dynamic>> _savedPaymentMethods = [];
  bool _isFetchingPayments = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    if (locationProvider.selectedLocation != null) {
      _selectedLocation = locationProvider.selectedLocation;
    }
    _fetchInitialData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        _fetchSavedLocations();
      }
    }
  }

  Future<void> _fetchInitialData() async {
    await _fetchSavedLocations();
    await _fetchSavedPaymentMethods();
  }

  Future<void> _fetchSavedLocations() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isFetchingLocations = false);
      return;
    }
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('deliveryLocations')
          .orderBy('addedOn', descending: true)
          .get();
      final locations = snapshot.docs.map((doc) {
        final data = doc.data();
        IconData icon = Icons.location_on;
        if (data.containsKey('label')) {
          switch (data['label'].toLowerCase()) {
            case 'home': icon = Icons.home_outlined; break;
            case 'work': icon = Icons.work_outline; break;
            default: icon = Icons.location_on_outlined;
          }
        }
        return {
          'docId': doc.id,
          'label': data['label'] ?? 'N/A',
          'address': data['address'] ?? 'No address',
          'phoneNumber': data['phoneNumber'] ?? 'No phone number',
          'icon': icon,
        };
      }).toList();
      if (mounted) {
        setState(() {
          _savedLocations = locations;
          if (_selectedLocation == null && _savedLocations.isNotEmpty) {
            _selectedLocation = _savedLocations.first;
          }
          _isFetchingLocations = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isFetchingLocations = false);
        _showSnackBar("Error fetching locations: $e", Colors.red);
      }
    }
  }

  Future<void> _fetchSavedPaymentMethods() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isFetchingPayments = false);
      return;
    }
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('paymentMethods')
          .get();
      final methods = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'type': data['name'],
          'iconPath': data.containsKey('iconPath') ? data['iconPath'] : null
        };
      }).toList();
      if (mounted) {
        setState(() {
          _savedPaymentMethods = methods;
          if (_savedPaymentMethods.isNotEmpty) {
            _selectedPaymentMethod = _savedPaymentMethods.first['type'];
          } else {
            _selectedPaymentMethod = '';
          }
          _isFetchingPayments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isFetchingPayments = false);
        _showSnackBar("Error fetching payment methods: $e", Colors.red);
      }
    }
  }

  void _handleSubmit(CartProvider cart) {
    if (_selectedLocation == null) {
      _showSnackBar("Please select a delivery location.", Colors.red);
      return;
    }
    if (cart.items.isEmpty) {
      _showSnackBar("Your cart is empty.", Colors.orange);
      return;
    }
    if (_selectedPaymentMethod.isEmpty) {
      _showSnackBar("Please add and select a payment method.", Colors.red);
      return;
    }
    _placeOrder();
  }

  void _showLocationSelectionSheet() async {
    setState(() => _isFetchingLocations = true);
    await _fetchSavedLocations();
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Select a Delivery Location",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (_isFetchingLocations)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: CircularProgressIndicator(),
                        )
                      else if (_savedLocations.isEmpty)
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Text("No saved locations found."))
                      else
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _savedLocations.length,
                            itemBuilder: (ctx, index) {
                              final location = _savedLocations[index];
                              final isSelected = _selectedLocation != null &&
                                  _selectedLocation!['docId'] == location['docId'];
                              return ListTile(
                                leading: Icon(location['icon'], color: Colors.grey[700]),
                                title: Text(location['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(location['address'],
                                    maxLines: 2, overflow: TextOverflow.ellipsis),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle,
                                    color: Colors.orange)
                                    : null,
                                onTap: () {
                                  setState(() => _selectedLocation = location);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.add_location_alt_outlined,
                            color: Colors.orange),
                        title: const Text("Add New Location",
                            style: TextStyle(
                                color: Colors.orange, fontWeight: FontWeight.bold)),
                        onTap: () async {
                          Navigator.pop(context);
                          final newLocationAdded = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNewLocationScreen(),
                            ),
                          );
                          if (newLocationAdded == true) {
                            await _fetchSavedLocations();
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double deliveryFee = 0.00;
    double total = (cart.totalAmount - _voucherDiscount) + deliveryFee;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: const Text('Confirm Order',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: _buildSubmitButton(cart),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDeliveryCard(),
            const SizedBox(height: 20),
            _buildOrderSummaryCard(cart, cart.totalAmount, deliveryFee, total),
            const SizedBox(height: 20),
            _buildVoucherCard(),
            const SizedBox(height: 20),
            _buildPaymentSelectionSection(total),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return _buildCard(
      child: InkWell(
        onTap: _showLocationSelectionSheet,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery to',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isFetchingLocations)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_selectedLocation == null)
              Center(
                child: Column(
                  children: [
                    const Text(
                      "No delivery location selected.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _showLocationSelectionSheet,
                      child: const Text("Select or Add a Location"),
                    ),
                  ],
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on,
                        color: Colors.orange, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedLocation!['label'] ?? "Address",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedLocation!['address'] ?? "Address not available",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _selectedLocation == null) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    try {
      double total = (cart.totalAmount - _voucherDiscount);
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();

      await orderRef.set({
        'orderId': orderRef.id,
        'userId': user.uid,
        'orderDate': Timestamp.now(),
        'status': 'Placed',
        'paymentMethod': _selectedPaymentMethod,
        'totalAmount': total,
        'items': cart.items.values.map((item) => {
          'id': item.id,
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
          'image': item.image,
        }).toList(),
        'deliveryAddress': _selectedLocation!['address'],
        'deliveryLabel': _selectedLocation!['label'],
        'restaurantName': cart.restaurantName,
        'restaurantImage': cart.restaurantImage,
      });

      locationProvider.updateSelectedLocation(_selectedLocation!);
      _simulateDelivery(orderRef.id);
      cart.clearCart();

      if (mounted) {
        setState(() => _voucherDiscount = 0.0);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to place order: ${e.toString()}', Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildOrderSummaryCard(
      CartProvider cart, double subtotal, double deliveryFee, double total) {
    final cartItems = cart.items.values.toList();
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cart.restaurantName ?? 'Your Order',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87)),
          const SizedBox(height: 20),
          if (cartItems.isEmpty)
            const Center(
                child: Text('Your cart is empty',
                    style: TextStyle(color: Colors.grey)))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) =>
                  _buildOrderItem(cartItems[index]),
            ),
          const SizedBox(height: 20),
          const Divider(color: Colors.grey, thickness: 0.5),
          const SizedBox(height: 16),
          _buildPriceRow('Subtotal (${cart.items.length} items)', subtotal),
          const SizedBox(height: 8),
          _buildPriceRow('Delivery', deliveryFee),
          const SizedBox(height: 8),
          _buildPriceRow('Voucher', -_voucherDiscount, isDiscount: true),
          const SizedBox(height: 12),
          const Divider(color: Colors.grey, thickness: 0.5),
          const SizedBox(height: 12),
          _buildPriceRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPaymentSelectionSection(double total) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_isFetchingPayments)
            const Center(child: CircularProgressIndicator())
          else if (_savedPaymentMethods.isEmpty)
            Center(
                child: Column(children: [
                  const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("No payment methods found.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16))),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentMethodsScreen()));
                      },
                      child: const Text("Add a Method"))
                ]))
          else
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _savedPaymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _savedPaymentMethods[index];
                  final bool isSelected =
                      _selectedPaymentMethod == method['type'];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedPaymentMethod = method['type']),
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange[50] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey.shade300,
                            width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(children: [
                            Image.asset(
                                method['iconPath'] ??
                                    (method['type'] == 'Cash'
                                        ? 'assets/Images/cash_logo.png'
                                        : 'assets/Images/paypal_logo.png'),
                                width: 24,
                                height: 24,
                                errorBuilder: (c, e, s) =>
                                const Icon(Icons.payment)),
                            const SizedBox(width: 8),
                            Text(method['type'],
                                style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                          Text('\$${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(CartProvider cart) {
    final bool isButtonDisabled =
        _isLoading || _savedPaymentMethods.isEmpty || _selectedLocation == null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : () => _handleSubmit(cart),
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF3A938),
            disabledBackgroundColor: Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 0),
        child: _isLoading
            ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2))
            : const Text('Submit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _buildOrderItem(CartItem item) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.fastfood, color: Colors.grey))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => cart.removeSingleItem(item.id),
                            icon: const Icon(Icons.remove, size: 18),
                            constraints: const BoxConstraints(
                                minWidth: 36, minHeight: 36),
                            padding: EdgeInsets.zero),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(item.quantity.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                        IconButton(
                            onPressed: () {
                              final currentRestaurantName = cart.restaurantName;
                              final currentRestaurantImage = cart.restaurantImage;
                              if (currentRestaurantName != null && currentRestaurantImage != null) {
                                cart.addItem(
                                  item.id,
                                  item.price,
                                  item.name,
                                  item.image,
                                  restaurantName: currentRestaurantName,
                                  restaurantImage: currentRestaurantImage,
                                );
                              }
                            },
                            icon: const Icon(Icons.add, size: 18),
                            constraints: const BoxConstraints(
                                minWidth: 36, minHeight: 36),
                            padding: EdgeInsets.zero),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text('\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFF3A938))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String title, double amount,
      {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : 16,
                color: isTotal ? Colors.black87 : Colors.grey[700])),
        Text(
            isDiscount && amount == 0
                ? '-'
                : '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                fontSize: isTotal ? 18 : 16,
                color: isTotal
                    ? const Color(0xFFF3A938)
                    : isDiscount
                    ? Colors.red
                    : Colors.black87)),
      ],
    );
  }

  Widget _buildVoucherCard() {
    return _buildCard(
      child: Row(
        children: [
          Icon(Icons.local_offer_outlined, color: Colors.orange[600], size: 24),
          const SizedBox(width: 16),
          const Expanded(
              child: Text('Add Voucher',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87))),
          TextButton(
            onPressed: _showVoucherBottomSheet,
            style: TextButton.styleFrom(
                backgroundColor: Colors.orange[50],
                foregroundColor: Colors.orange[800],
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: const Text('Add',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showVoucherBottomSheet() {
    TextEditingController voucherController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.5))),
            const SizedBox(height: 20),
            const Text('Add Voucher',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: voucherController,
              decoration: InputDecoration(
                hintText: 'Enter voucher code',
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.orange)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleApplyVoucher(voucherController.text, ctx),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF3A938),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              child: const Text('Apply Voucher',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handleApplyVoucher(String code, BuildContext dialogContext) {
    String trimmedCode = code.trim().toUpperCase();
    if (trimmedCode == "DISCOUNT10") {
      setState(() => _voucherDiscount = 10.0);
      _showSnackBar('Voucher applied!', Colors.green);
    } else if (trimmedCode.isEmpty) {
      _showSnackBar('Please enter a voucher code', Colors.red);
      return;
    } else {
      _showSnackBar('Invalid voucher code', Colors.red);
    }
    Navigator.of(dialogContext).pop();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('You ordered successfully',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
                'Your order is confirmed and will be delivered within 20 minutes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 14, height: 1.4)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF3A938),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              child: const Text('KEEP BROWSING',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _simulateDelivery(String orderId) {
    final orderRef =
    FirebaseFirestore.instance.collection('orders').doc(orderId);

    Future.delayed(const Duration(seconds: 5), () {
      orderRef.update({'status': 'Preparing'});
    });
    Future.delayed(const Duration(seconds: 15), () {
      orderRef.update({'status': 'On The Way'});
    });
    Future.delayed(const Duration(minutes: 20), () {
      orderRef.update({'status': 'Delivered'});
    });
  }
}