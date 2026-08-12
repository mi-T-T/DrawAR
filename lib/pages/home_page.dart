import 'drawing_page.dart';

import 'package:flutter/material.dart';
import '../screens/camera_screen.dart';

class HomePage extends StatefulWidget {
  final int index;

  const HomePage({super.key, this.index = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  int currentBottomNavIndex = 0;

  final Set<String> _favoriteItems = {};

  final List<String> categories = [
    'Tất cả',
    'Anime',
    'Chibi',
    'Cute',
    'Animals',
    'Dễ vẽ',
  ];

  final List<Map<String, String>> animeList = [
    {
      'title': 'Anime nữ 01',
      'level': 'Dễ',
      'image': 'assets/dataset/anime_female/AF001.jpg',
    },
    {
      'title': 'Anime nữ 02',
      'level': 'Dễ',
      'image': 'assets/dataset/anime_female/AF002.jpg',
    },
    {
      'title': 'Anime nữ 03',
      'level': 'TB',
      'image': 'assets/dataset/anime_female/AF003.jpg',
    },
    {
      'title': 'Anime nữ 04',
      'level': 'TB',
      'image': 'assets/dataset/anime_female/AF004.jpg',
    },
    {
      'title': 'Anime nữ 05',
      'level': 'Khó',
      'image': 'assets/dataset/anime_female/AF005.jpg',
    },
    {
      'title': 'Anime nữ 06',
      'level': 'Dễ',
      'image': 'assets/dataset/anime_female/AF006.jpg',
    },
  ];

  void _navigateToCamera(BuildContext context, {String? imageUrl}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(selectedImage: imageUrl),
      ),
    );
  }

  void _openDrawingPage(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrawingPage(imagePath: imagePath),
      ),
    );
  }

  void _toggleFavorite(String title) {
    setState(() {
      if (_favoriteItems.contains(title)) {
        _favoriteItems.remove(title);
      } else {
        _favoriteItems.add(title);
      }
    });
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  Icon(Icons.draw_rounded, color: Color(0xFFFF4081), size: 28),
                  SizedBox(width: 8),
                  Text(
                    'AR Drawing Anime',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm nhân vật Anime, Chibi...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFFFF4081),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 2. Banner Giới thiệu / Khuyến khích Convert Ảnh
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF4081), Color(0xFF7C4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4081).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tạo nét vẽ từ Ảnh cá nhân',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Chọn ảnh từ thư viện để chuyển thành hình phác thảo AR',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _navigateToCamera(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFFF4081),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          icon: const Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 18,
                          ),
                          label: const Text(
                            'Chọn ảnh',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 60,
                    color: Colors.white24,
                  ),
                ],
              ),
            ),

            // 3. Danh mục Chips (Categories)
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedCategory == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: isSelected,
                      selectedColor: const Color(0xFFFF4081),
                      backgroundColor: const Color(0xFF1E1E1E),
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (bool selected) {
                        setState(() => selectedCategory = index);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 4. Lưới ảnh mẫu Anime (Card UI Tối Ưu)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: animeList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final item = animeList[index];
                  final isFav = _favoriteItems.contains(item['title']);
                  return GestureDetector(
                    onTap: () => _openDrawingPage(item['image']!),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              item['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                            // Badge cấp độ (Độ khó)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['level']!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFFF4081),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // Nút Yêu thích
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => _toggleFavorite(item['title']!),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.black.withOpacity(
                                    0.5,
                                  ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav
                                        ? const Color(0xFFFF4081)
                                        : Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            // Title Overlay ở phía dưới
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.85),
                                    ],
                                  ),
                                ),
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonsTab() {
    return const SafeArea(
      child: Center(
        child: Text(
          'Màn hình Bài học vẽ (Dưới dạng Step-by-Step)',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFavoritesTab() {
    final favList = animeList
        .where((item) => _favoriteItems.contains(item['title']))
        .toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Danh sách Yêu thích',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: favList.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có hình ảnh nào được lưu vào Yêu thích',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final item = favList[index];

                      return GestureDetector(
                        onTap: () => _openDrawingPage(item['image']!),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF252525),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(item['image']!, fit: BoxFit.cover),

                                // Nút bỏ yêu thích
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _toggleFavorite(item['title']!),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.black.withOpacity(
                                        0.5,
                                      ),
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Color(0xFFFF4081),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),

                                // Tên ảnh
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.85),
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildProfileTab() {
    return const SafeArea(
      child: Center(
        child: Text(
          'Tài khoản cá nhân',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      body: IndexedStack(
        index: currentBottomNavIndex,
        children: [
          _buildHomeTab(),
          _buildLessonsTab(),
          _buildFavoritesTab(),
          _buildProfileTab(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            currentBottomNavIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFFFF4081),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Bài học',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }
}
