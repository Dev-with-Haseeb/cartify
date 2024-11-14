import 'package:cartify/models/category_model.dart';
import 'package:cartify/providers/product_provider.dart';
import 'package:cartify/screens/cart_screen/cart_screen.dart';
import 'package:cartify/screens/category_products_screen/category_products_screen.dart';
import 'package:cartify/widgets/products_grid.dart';
import 'package:cartify/screens/products_screen/products_screen.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirebaseFirestore.instance;
  final FocusNode _searchFocusNode = FocusNode();

  String _fullName = '';
  bool _isLoading = true;
  String _searchTerm = '';
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<List<Category>> fetchCategories() async {
    final querySnapshot = await firestore.collection('categories').get();
    return querySnapshot.docs.map((doc) {
      return Category(
        id: doc['id'],
        name: doc['name'],
        icon: doc['icon'],
      );
    }).toList();
  }

  void _searchProducts(String query) {
    setState(() {
      _searchTerm = query;
    });
  }

  Future<void> _fetchUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user document from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final firstName = userDoc.data()!['firstName'];
          final lastName = userDoc.data()!['lastName'];

          setState(() {
            _fullName = '$firstName $lastName';
            _isLoading = false;
          });
        }
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching username: $error')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      if (productProvider.products.isEmpty || _isLoading) {
        return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
              color: AppColors.mainColor,
            )));
      }

      final displayedProducts = _searchTerm.isEmpty
          ? productProvider.products.take(4).toList()
          : productProvider.products
              .where((product) => product.name
                  .toLowerCase()
                  .contains(_searchTerm.toLowerCase()))
              .toList();

      return GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.4,
                  decoration: const BoxDecoration(color: AppColors.mainColor),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.6),
                  height: MediaQuery.of(context).size.height / 1.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Good Day for Shopping',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      Text(
                                        _fullName,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const CartScreen(),
                                        withNavBar:
                                            false, // Hides the bottom navigation bar
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.shopping_bag,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon: const Icon(Icons.search),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle: const TextStyle(
                                      color: AppColors.mainColor,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 0),
                                    ),
                                  ),
                                  focusNode: _searchFocusNode,
                                  onChanged: _searchProducts,
                                  style: const TextStyle(
                                    color: AppColors.mainColor,
                                  ),
                                  cursorColor: AppColors.mainColor,
                                ),
                              ),
                              Text(
                                'Categories',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _categories.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: SizedBox(
                                        width: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                PersistentNavBarNavigator
                                                    .pushNewScreen(
                                                  context,
                                                  screen:
                                                      CategoryProductsScreen(
                                                          categoryId:
                                                              _categories[index]
                                                                  .id
                                                                  .toString()),
                                                  withNavBar:
                                                      false, // Hides the bottom navigation bar
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino,
                                                );
                                              },
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  getIconFromString(
                                                      _categories[index].icon),
                                                  size: 25, // Set the icon size
                                                  color: AppColors
                                                      .mainColor, // Set your desired color
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              _categories[index].name,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _searchTerm.isEmpty
                                  ? 'Popular Products'
                                  : 'Searched Products',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: const ProductsScreen(),
                                  withNavBar:
                                      false, // Hides the bottom navigation bar
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 30, 131, 214)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                minimumSize: const Size(50, 24),
                              ),
                              child: Text(
                                'View All',
                                style: GoogleFonts.robotoCondensed(
                                    color:
                                        const Color.fromARGB(255, 30, 131, 214),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ProductsGrid(
                          products: displayedProducts,
                          itemCount: displayedProducts.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
