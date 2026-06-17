import 'package:flutter/material.dart';
import '../models/product.dart';

class User {
  final String name;
  final String email;
  final String avatarUrl;
  final String phone;

  const User({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.phone,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class AuthNotifier extends ChangeNotifier {
  static final AuthNotifier instance = AuthNotifier._internal();
  AuthNotifier._internal();

  bool _isLoggedIn = false;
  User? _user;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (!email.contains('@') || password.length < 4) {
      return false;
    }

    _isLoggedIn = true;
    _user = User(
      name: email.split('@')[0].toUpperCase(),
      email: email.toLowerCase(),
      avatarUrl:
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200",
      phone: "+91 98765 43210",
    );
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}

class CartNotifier extends ChangeNotifier {
  static final CartNotifier instance = CartNotifier._internal();
  CartNotifier._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemsCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) {
      final price = item.product.discountPrice ?? item.product.price;
      return sum + (price * item.quantity);
    });
  }

  bool isInCart(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }

  int getProductQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    return index >= 0 ? _items[index].quantity : 0;
  }

  void addItem(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class LanguageNotifier extends ChangeNotifier {
  static final LanguageNotifier instance = LanguageNotifier._internal();
  LanguageNotifier._internal();

  String _currentLanguage = "English";

  String get currentLanguage => _currentLanguage;

  final Map<String, Map<String, String>> _translations = {
    "English": {
      "welcome": "Welcome",
      "partner": "Partner",
      "dashboard": "Business Dashboard",
      "search": "Search fabrics, weaves, categories...",
      "catalog": "Browse Catalog",
      "categories": "Categories",
      "inquiry": "B2B Inquiry",
      "direct_order": "Direct Order",
      "items": "items",
      "showing": "Showing",
      "apply_filters": "Apply Filters",
      "filters": "Filters",
      "news":
          "🔥 ANNOUNCEMENT: Fresh collection of Handloom Banarasi Silk Sarees & Organic Linen Fabric rolls just arrived! | Enjoy 15% discount for Gold tier members on bulk B2B purchases! | Order now via direct WhatsApp checkout! 🔥",
    },
    "Hindi": {
      "welcome": "स्वागत है",
      "partner": "साझेदार",
      "dashboard": "व्यापार डैशबोर्ड",
      "search": "कपड़े, बुनाई, श्रेणियां खोजें...",
      "catalog": "कैटलॉग ब्राउज़ करें",
      "categories": "श्रेणियां",
      "inquiry": "बी2बी पूछताछ",
      "direct_order": "सीधा ऑर्डर",
      "items": "आइटम",
      "showing": "दिखा रहा है",
      "apply_filters": "फ़िल्टर लागू करें",
      "filters": "फ़िल्टर",
      "news":
          "🔥 घोषणा: हैंडलूम बनारसी सिल्क साड़ियों और ऑर्गेनिक लिनन फैब्रिक रोल का नया कलेक्शन अभी आया है! | थोक बी2बी खरीद पर गोल्ड टियर सदस्यों के लिए 15% की छूट! | सीधे व्हाट्सएप चेकआउट के माध्यम से अभी ऑर्डर करें! 🔥",
    },
    "Gujarati": {
      "welcome": "સ્વાગત છે",
      "partner": "ભાગીદાર",
      "dashboard": "બિઝનેસ ડેશબોર્ડ",
      "search": "કાપડ, વણાટ, શ્રેણીઓ શોધો...",
      "catalog": "કેટલોગ બ્રાઉઝ કરો",
      "categories": "શ્રેણીઓ",
      "inquiry": "બી2બી પૂછપરછ",
      "direct_order": "સીધો ઓર્ડર",
      "items": "આઇટમ",
      "showing": "દર્શાવે છે",
      "apply_filters": "ફિલ્ટર્સ લાગુ કરો",
      "filters": "ફિલ્ટર્સ",
      "news":
          "🔥 જાહેરાત: હેન્ડલૂમ બનારસી સિલ્ક સાડીઓ અને ઓર્ગેનિક લિનન ફેબ્રિક રોલ્સનું નવું કલેક્શન હમણાં જ આવ્યું છે! | બલ્ક B2B ખરીદી પર ગોલ્ડ ટિયર સભ્યો માટે 15% ડિસ્કાઉન્ટનો આનંદ માણો! | સીધા વ્હોટ્સએપ ચેકઆઉટ દ્વારા હમણાં જ ઓર્ડર કરો! 🔥",
    },
    "Tamil": {
      "welcome": "வரவேற்பு",
      "partner": "பங்குதாரர்",
      "dashboard": "வணிக டாஷ்பору",
      "search": "துணிகள், நெசவுகள், வகைகளைத் தேடுங்கள்...",
      "catalog": "பட்டியலை உலாவுக",
      "categories": "வகைகள்",
      "inquiry": "பி2பி விசாரணை",
      "direct_order": "நேரடி ஆர்டர்",
      "items": "பொருட்கள்",
      "showing": "காண்பிக்கிறது",
      "apply_filters": "வடிப்பான்களைப் பயன்படுத்து",
      "filters": "வடிப்பான்கள்",
      "news":
          "🔥 அறிவிப்பு: கைத்தறி பனாரசி பட்டு புடவைகள் மற்றும் ஆர்கானிக் லினன் துணி ரோல்களின் புதிய சேகரிப்பு இப்போது வந்துள்ளது! | மொத்த B2B கொள்முதல் மீது கோல்ட் அடுக்கு உறுப்பினர்களுக்கு 15% தள்ளுபடி! | நேரடி வாட்ஸ்அப் செக்அவுட் மூலம் இப்போது ஆர்டர் செய்யுங்கள்! 🔥",
    },
    "Spanish": {
      "welcome": "Bienvenido",
      "partner": "Socio",
      "dashboard": "Panel de Negocios",
      "search": "Buscar telas, tejidos, categorías...",
      "catalog": "Explorar Catálogo",
      "categories": "Categorías",
      "inquiry": "Consulta B2B",
      "direct_order": "Pedido Directo",
      "items": "artículos",
      "showing": "Mostrando",
      "apply_filters": "Aplicar Filtros",
      "filters": "Filtros",
      "news":
          "🔥 ANUNCIO: ¡Acaba de llegar una nueva colección de saris de seda de Banarasi hechos a mano y rollos de tela de lino orgánico! | ¡Disfrute de un 15% de descuento para miembros del nivel Gold en compras al por mayor B2B! | ¡Ordene ahora a través del pago directo de WhatsApp! 🔥",
    },
    "French": {
      "welcome": "Bienvenue",
      "partner": "Partenaire",
      "dashboard": "Tableau de Bord Commercial",
      "search": "Rechercher des tissus, armures, catégories...",
      "catalog": "Parcourir le Catalogue",
      "categories": "Catégories",
      "inquiry": "Demande B2B",
      "direct_order": "Commande Directe",
      "items": "articles",
      "showing": "Affichage de",
      "apply_filters": "Appliquer les Filtres",
      "filters": "Filtres",
      "news":
          "🔥 ANNONCE: Une nouvelle collection de saris en soie Banarasi tissés à la main et de rouleaux de lin bio vient d'arriver ! | Bénéficiez de 15% de réduction pour les membres Gold sur les achats B2B en gros ! | Commandez dès maintenant via WhatsApp ! 🔥",
    },
    "German": {
      "welcome": "Willkommen",
      "partner": "Partner",
      "dashboard": "Business-Dashboard",
      "search": "Stoffe, Bindungen, Kategorien suchen...",
      "catalog": "Katalog Durchsuchen",
      "categories": "Kategorien",
      "inquiry": "B2B-Anfrage",
      "direct_order": "Direktbestellung",
      "items": "Artikel",
      "showing": "Angezeigt",
      "apply_filters": "Filter Anwenden",
      "filters": "Filter",
      "news":
          "🔥 ANKÜNDIGUNG: Eine neue Kollektion handgewebter Banarasi-Seidensaris und Bio-Leinenstoffrollen ist eingetroffen! | Genießen Sie 15% Rabatt für Gold-Mitglieder bei B2B-Großeinkäufen! | Bestellen Sie jetzt direkt über WhatsApp! 🔥",
    },
    "Chinese": {
      "welcome": "欢迎",
      "partner": "合作伙伴",
      "dashboard": "业务仪表板",
      "search": "搜索面料、织法、类别...",
      "catalog": "浏览目录",
      "categories": "类别",
      "inquiry": "B2B 询价",
      "direct_order": "直接下单",
      "items": "件商品",
      "showing": "显示",
      "apply_filters": "应用筛选",
      "filters": "筛选",
      "news":
          "🔥 公告：手工织造的 Banarasi 蚕丝纱丽和有机亚麻面料卷刚刚到货！| 金牌会员尊享 B2B 大宗采购 15% 折扣！| 立即通过 WhatsApp 直接结算下单！ 🔥",
    },
    "Arabic": {
      "welcome": "مرحباً",
      "partner": "شريك",
      "dashboard": "لوحة التحكم للأعمال",
      "search": "البحث عن الأقمشة، المنسوجات، الفئات...",
      "catalog": "تصفح الكتالوج",
      "categories": "الفئات",
      "inquiry": "استفسار B2B",
      "direct_order": "طلب مباشر",
      "items": "عناصر",
      "showing": "عرض",
      "apply_filters": "تطبيق التصفية",
      "filters": "الفلاتر",
      "news":
          "🔥 إعلان: وصلت للتو تشكيلة جديدة من ساري الحرير البنارسي اليدوي ولفائف الكتان العضوي! | استمتع بخصم 15% للأعضاء الذهبيين على مشتريات B2B بالجملة! | اطلب الآن عبر WhatsApp! 🔥",
    },
    "Japanese": {
      "welcome": "ようこそ",
      "partner": "パートナー",
      "dashboard": "ビジネスダッシュボード",
      "search": "生地、織り方、カテゴリを検索...",
      "catalog": "カタログを閲覧",
      "categories": "カテゴリ",
      "inquiry": "B2B問い合わせ",
      "direct_order": "直接注文",
      "items": "点の商品",
      "showing": "表示中",
      "apply_filters": "フィルターを適用",
      "filters": "フィルター",
      "news":
          "🔥 お知らせ：手織りのバラナシシルクサリーとオーガニックリネン生地ロールの最新コレクションが入荷しました！ | ゴールド会員様限定、B2Bまとめ買いで15%OFF！ | WhatsAppから今すぐ直接ご注文いただけます！ 🔥",
    },
  };

  void changeLanguage(String newLanguage) {
    if (_translations.containsKey(newLanguage)) {
      _currentLanguage = newLanguage;
      notifyListeners();
    }
  }

  String translate(String key) {
    return _translations[_currentLanguage]?[key] ??
        _translations["English"]?[key] ??
        key;
  }
}
