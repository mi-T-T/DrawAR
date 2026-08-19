import 'drawing_page.dart';
import 'package:flutter/material.dart';
import '../screens/camera_screen.dart';
import '../screens/text_input_screen.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 1. Cập nhật danh mục bao gồm Genshin & Nam/Nữ Anime
  final List<String> categories = [
    'Tất cả',
    'Anime Nữ',
    'Anime Nam',
    'Chibi',
    'Genshin',
    'Dễ vẽ',
  ];

  // 2. Cập nhật Dataset theo đúng cấu trúc dataset (anime_female, anime_male, chibi, genshin)
  final List<Map<String, String>> animeList = [
    // Anime Female
    {
      'title': 'Anime nữ 01',
      'level': 'Dễ',
      'category': 'Anime Nữ',
      'image': 'assets/dataset/anime_female/AF001.jpg',
    },
    {
      'title': 'Anime nữ 02',
      'level': 'Dễ',
      'category': 'Anime Nữ',
      'image': 'assets/dataset/anime_female/AF002.jpg',
    },
    {
      'title': 'Anime nữ 03',
      'level': 'TB',
      'category': 'Anime Nữ',
      'image': 'assets/dataset/anime_female/AF003.jpg',
    },
    {
      'title': 'Anime nữ 04',
      'level': 'TB',
      'category': 'Anime Nữ',
      'image': 'assets/dataset/anime_female/AF004.jpg',
    },
    {
      'title': 'Anime nữ 05',
      'level': 'Khó',
      'category': 'Anime Nữ',
      'image': 'assets/dataset/anime_female/AF005.jpg',
    },

    // Anime Male
    {
      'title': 'Anime nam 01',
      'level': 'Dễ',
      'category': 'Anime Nam',
      'image': 'assets/dataset/anime_male/AM001.jpg',
    },
    {
      'title': 'Anime nam 02',
      'level': 'TB',
      'category': 'Anime Nam',
      'image': 'assets/dataset/anime_male/AM002.jpg',
    },
    {
      'title': 'Anime nam 03',
      'level': 'Khó',
      'category': 'Anime Nam',
      'image': 'assets/dataset/anime_male/AM003.jpg',
    },

    // Chibi
    {
      'title': 'Chibi 01',
      'level': 'Dễ',
      'category': 'Chibi',
      'image': 'assets/dataset/chibi/CB001.jpg',
    },
    {
      'title': 'Chibi 02',
      'level': 'Dễ',
      'category': 'Chibi',
      'image': 'assets/dataset/chibi/CB002.jpg',
    },

    // Genshin
    {
      'title': 'Genshin 01',
      'level': 'TB',
      'category': 'Genshin',
      'image': 'assets/dataset/genshin/GI001.jpg',
    },
    {
      'title': 'Genshin 02',
      'level': 'Khó',
      'category': 'Genshin',
      'image': 'assets/dataset/genshin/GI002.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    currentBottomNavIndex = widget.index;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Lọc dữ liệu theo Từ khóa Tìm kiếm, Danh mục hoặc Độ khó "Dễ vẽ"
  List<Map<String, String>> get _filteredAnimeList {
    return animeList.where((item) {
      final matchesSearch = item['title']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      bool matchesCategory = true;
      if (selectedCategory != 0) {
        final selectedCatName = categories[selectedCategory];
        if (selectedCatName == 'Dễ vẽ') {
          matchesCategory = item['level'] == 'Dễ';
        } else {
          matchesCategory = item['category'] == selectedCatName;
        }
      }
      return matchesSearch && matchesCategory;
    }).toList();
  }

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

  void _openTextInputPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TextInputScreen()),
    );
  }

  Widget _buildHomeTab() {
    final displayedList = _filteredAnimeList;

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

            // Thanh Tìm Kiếm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm nhân vật Anime, Genshin, Chibi...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFFFF4081),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
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

            // Banner
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
                        Row(
                          children: [
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
                                  horizontal: 12,
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
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _openTextInputPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              icon: const Icon(Icons.text_fields, size: 18),
                              label: const Text('Vẽ chữ'),
                            ),
                          ],
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

            // Thanh danh mục Categories
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

            // Lưới hiển thị danh sách ảnh
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: displayedList.isEmpty
                  ? Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const Text(
                        'Không tìm thấy hình ảnh phù hợp',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final item = displayedList[index];
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  ),
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
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _toggleFavorite(item['title']!),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.black
                                            .withOpacity(0.5),
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

  // Màn hình Nghệ thuật chữ
  Widget _buildTextArtTab() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.text_fields, size: 80, color: Color(0xFFFF4081)),
            const SizedBox(height: 16),
            const Text(
              'Nghệ thuật chữ (Text Art)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chuyển văn bản thành các mẫu chữ phác thảo AR',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openTextInputPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4081),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Bắt đầu vẽ chữ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Màn hình Yêu thích
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

  // Trang cá nhân
  Widget _buildProfileTab() {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                '👤 Trang cá nhân',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFFF4081),
                child: CircleAvatar(
                  radius: 42,
                  backgroundImage: AssetImage(
                    'assets/images/default_avatar.png',
                  ),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Họa Sĩ AR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '@artist_ar',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Đam mê vẽ phác thảo Anime & Chibi 🎨 | Sáng tạo không giới hạn',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Thống kê
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('Số tranh đã vẽ', '12'),
                    Container(height: 30, width: 1, color: Colors.grey[800]),
                    _buildStatItem('Lượt thích', '128'),
                    Container(height: 30, width: 1, color: Colors.grey[800]),
                    _buildStatItem('Yêu thích', '${_favoriteItems.length}'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFFFF4081)),
                title: const Text(
                  '❤️ Tranh yêu thích đã lưu',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_favoriteItems.length}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () {
                  setState(() {
                    currentBottomNavIndex = 2;
                  });
                },
              ),

              const Divider(color: Colors.white10),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '🎨 Tranh của tôi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const TabBar(
                indicatorColor: Color(0xFFFF4081),
                labelColor: Color(0xFFFF4081),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Đã hoàn thành'),
                  Tab(text: 'Bản nháp'),
                  Tab(text: 'Đã đăng'),
                ],
              ),

              SizedBox(
                height: 250,
                child: TabBarView(
                  children: [
                    _buildGridMyArt([]),
                    _buildGridMyArt([]),
                    _buildGridMyArt([]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildGridMyArt(List<String> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Chưa có dữ liệu', style: TextStyle(color: Colors.grey)),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(items[index], fit: BoxFit.cover),
          ),
        );
      },
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
          _buildTextArtTab(),
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
            icon: Icon(Icons.text_fields),
            label: 'Nghệ thuật chữ',
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
