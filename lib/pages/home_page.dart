import 'package:flutter/material.dart';
import '../screens/camera_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  final List<String> categories = [
    'Tất cả',
    'Anime',
    'Chibi',
    'Cute',
    'Animals',
    'Dễ vẽ',
  ];

  // Danh sách ảnh mẫu Anime
  final List<Map<String, String>> animeList = [
    {
      'title': 'Goku Chibi',
      'level': 'Dễ',
      'image': 'https://picsum.photos/300/400?random=10',
    },
    {
      'title': 'Naruto Eyes',
      'level': 'TB',
      'image': 'https://picsum.photos/300/400?random=11',
    },
    {
      'title': 'Cat Girl',
      'level': 'Dễ',
      'image': 'https://picsum.photos/300/400?random=12',
    },
    {
      'title': 'Luffy Gear 5',
      'level': 'Khó',
      'image': 'https://picsum.photos/300/400?random=13',
    },
    {
      'title': 'Chibi Nezuko',
      'level': 'Dễ',
      'image': 'https://picsum.photos/300/400?random=14',
    },
    {
      'title': 'Anya Forger',
      'level': 'Dễ',
      'image': 'https://picsum.photos/300/400?random=15',
    },
  ];

  void _navigateToCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.draw_rounded, color: Color(0xFFFF4081)),
            SizedBox(width: 8),
            Text(
              'Draw Anime AR',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined, color: Colors.white),
            tooltip: 'Tải ảnh của bạn',
            onPressed: () => _navigateToCamera(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Thanh Tìm Kiếm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm nhân vật Anime, Chibi...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFFF4081),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF252525),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 2. Banner Giới thiệu
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF4081), Color(0xFF7C4DFF)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tập vẽ Anime AR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Đặt điện thoại lên cốc & bắt đầu đồ nét ngay!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Danh mục Chips (Categories)
            SizedBox(
              height: 40,
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
                      backgroundColor: const Color(0xFF252525),
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

            // 4. Lưới ảnh mẫu Anime
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
                  return GestureDetector(
                    onTap: () => _navigateToCamera(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
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
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
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
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
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
}
