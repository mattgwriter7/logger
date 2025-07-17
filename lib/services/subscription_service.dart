import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// IMPORTANT: Your actual product IDs from Google Play Console
const String REGULAR_PLAN_ID = 'notey_note_regular_monthly';
const String SUPERUSER_PLAN_ID = 'notey_note_superuser_monthly';

enum SubscriptionPlan { none, regular, superuser }

class SubscriptionService {
  // Singleton pattern
  static SubscriptionService? _instance;
  static SubscriptionService get instance {
    _instance ??= SubscriptionService._internal();
    return _instance!;
  }
  SubscriptionService._internal(); // Private constructor
  
  static const String _subscriptionKey = 'current_subscription';
  
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  List<ProductDetails> _products = [];
  SubscriptionPlan _currentPlan = SubscriptionPlan.none;
  bool _isAvailable = false;
  String _statusMessage = 'Initializing...';
  bool _isInitialized = false;
  
  // Getters
  SubscriptionPlan get currentPlan => _currentPlan;
  bool get isAvailable => _isAvailable;
  String get statusMessage => _statusMessage;
  List<ProductDetails> get products => _products;
  bool get isInitialized => _isInitialized;
  
  // Stream controllers for updates
  final StreamController<SubscriptionPlan> _planController = 
      StreamController<SubscriptionPlan>.broadcast();
  Stream<SubscriptionPlan> get planStream => _planController.stream;
  
  final StreamController<String> _statusController = 
      StreamController<String>.broadcast();
  Stream<String> get statusStream => _statusController.stream;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _updateStatus('Checking if purchases are available...');
      
      // Check if in-app purchases are available
      _isAvailable = await _inAppPurchase.isAvailable();
      if (!_isAvailable) {
        _updateStatus('In-app purchases not available on this device');
        return;
      }
      
      _updateStatus('Loading saved subscription...');
      await _loadSavedSubscription();
      
      _updateStatus('Setting up purchase listener...');
      // Listen to purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () => _subscription.cancel(),
        onError: (error) {
          print('Purchase stream error: $error');
          _updateStatus('Purchase stream error: $error');
        },
      );
      
      _updateStatus('Loading products from store...');
      await _loadProducts();
      
      _updateStatus('Checking current subscription status...');
      await _checkSubscriptionStatus();
      
      _updateStatus('Ready!');
      _isInitialized = true;
      
    } catch (e) {
      _updateStatus('Initialization error: $e');
      print('Subscription service initialization error: $e');
    }
  }
  
  // Load products from store
  Future<void> _loadProducts() async {
    try {
      const Set<String> productIds = {REGULAR_PLAN_ID, SUPERUSER_PLAN_ID};
      final ProductDetailsResponse response = 
          await _inAppPurchase.queryProductDetails(productIds);
      
      if (response.error != null) {
        _updateStatus('Failed to load products: ${response.error!.message}');
        return;
      }
      
      _products = response.productDetails;
      
      if (_products.isEmpty) {
        _updateStatus('No products found. Check your product IDs in Google Play Console');
      } else {
        _updateStatus('Loaded ${_products.length} products');
        for (var product in _products) {
          print('Product: ${product.id} - ${product.title} - ${product.price}');
        }
      }
      
    } catch (e) {
      _updateStatus('Error loading products: $e');
    }
  }
  
  // Purchase a subscription
  Future<void> purchaseSubscription(String productId) async {
    try {
      _updateStatus('Starting purchase for $productId...');
      
      final ProductDetails? product = _products
          .where((p) => p.id == productId)
          .firstOrNull;
      
      if (product == null) {
        _updateStatus('Product not found: $productId');
        return;
      }
      
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );
      
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      _updateStatus('Purchase initiated...');
      
    } catch (e) {
      _updateStatus('Purchase error: $e');
    }
  }
  
  // Handle purchase updates
  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print('Purchase update: ${purchaseDetails.productID} - ${purchaseDetails.status}');
      
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        _updateStatus('Purchase successful!');
        _updateSubscriptionFromPurchase(purchaseDetails);
        
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
        
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        _updateStatus('Purchase restored!');
        _updateSubscriptionFromPurchase(purchaseDetails);
        
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        _updateStatus('Purchase error: ${purchaseDetails.error?.message ?? "Unknown error"}');
        
      } else if (purchaseDetails.status == PurchaseStatus.pending) {
        _updateStatus('Purchase pending...');
        
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        _updateStatus('Purchase canceled');
      }
    }
  }
  
  // Update subscription from purchase
  void _updateSubscriptionFromPurchase(PurchaseDetails purchase) {
    SubscriptionPlan newPlan = SubscriptionPlan.none;
    
    switch (purchase.productID) {
      case REGULAR_PLAN_ID:
        newPlan = SubscriptionPlan.regular;
        break;
      case SUPERUSER_PLAN_ID:
        newPlan = SubscriptionPlan.superuser;
        break;
    }
    
    _updateCurrentPlan(newPlan);
  }
  
  // Check subscription status (restore purchases)
  Future<void> checkSubscriptionStatus() async {
    try {
      _updateStatus('Restoring purchases...');
      await _inAppPurchase.restorePurchases();
      _updateStatus('Restore complete');
    } catch (e) {
      _updateStatus('Error restoring purchases: $e');
    }
  }
  
  // Internal restore method
  Future<void> _checkSubscriptionStatus() async {
    await checkSubscriptionStatus();
  }
  
  // Update current plan
  void _updateCurrentPlan(SubscriptionPlan plan) {
    _currentPlan = plan;
    _savePlanToPreferences(plan);
    _planController.add(plan);
  }
  
  // Save to SharedPreferences
  Future<void> _savePlanToPreferences(SubscriptionPlan plan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_subscriptionKey, plan.name);
  }
  
  // Load from SharedPreferences
  Future<void> _loadSavedSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final String? planName = prefs.getString(_subscriptionKey);
    
    if (planName != null) {
      try {
        _currentPlan = SubscriptionPlan.values
            .firstWhere((p) => p.name == planName);
      } catch (e) {
        _currentPlan = SubscriptionPlan.none;
      }
    }
  }
  
  // Update status message
  void _updateStatus(String status) {
    _statusMessage = status;
    _statusController.add(status);
    print('SubscriptionService: $status');
  }
  
  // Helper methods for checking subscription status
  bool get hasActiveSubscription => _currentPlan != SubscriptionPlan.none;
  bool get isRegularUser => _currentPlan == SubscriptionPlan.regular;
  bool get isSuperUser => _currentPlan == SubscriptionPlan.superuser;
  
  // Get product by ID
  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }
  
  // Dispose resources
  void dispose() {
    _subscription.cancel();
    _planController.close();
    _statusController.close();
  }
}