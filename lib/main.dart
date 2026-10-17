import 'package:flutter/material.dart';

const ink = Color(0xFF173D36);
const paper = Color(0xFFF7F4EA);
const coral = Color(0xFFD76D4E);

void main() => runApp(const FunGuyApp());

class FunGuyApp extends StatelessWidget {
  const FunGuyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'FunGuy · A little closer to nature',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: ink, surface: paper),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 43,
          height: 1.05,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 29,
          color: ink,
        ),
        titleLarge: TextStyle(fontFamily: 'Georgia', fontSize: 23, color: ink),
        bodyMedium: TextStyle(color: ink, height: 1.5),
      ),
    ),
    home: const FieldHome(),
  );
}

class Specimen {
  final String common, latin, habitat;
  const Specimen(this.common, this.latin, this.habitat);
}

const specimens = [
  Specimen(
    'Turkey tail',
    'Trametes versicolor',
    'Layered brackets · fallen wood',
  ),
  Specimen('Fly agaric', 'Amanita muscaria', 'Gilled mushroom · woodland'),
  Specimen('Chanterelle', 'Cantharellus cibarius', 'Ridges · woodland floor'),
];

class FieldHome extends StatefulWidget {
  const FieldHome({super.key});
  @override
  State<FieldHome> createState() => _FieldHomeState();
}

class _FieldHomeState extends State<FieldHome> {
  int page = 0;
  String query = '';
  final saved = <String>{};
  void explain(String title, String message) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: paper,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to exploring'),
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final filtered = specimens
        .where(
          (s) => '${s.common} ${s.latin}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: ink,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.forest_outlined,
                                color: paper,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'FunGuy',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: ink,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'FIELD NOTES\nSAN DIEGO, CA',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 1.6,
                                color: ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        if (page == 0) ...[
                          const Row(
                            children: [
                              Icon(
                                Icons.explore_outlined,
                                size: 14,
                                color: coral,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'A LITTLE CLOSER TO NATURE',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 2.2,
                                  fontWeight: FontWeight.w700,
                                  color: coral,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Small wonders.\nWild discoveries.',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Meet the fungi beneath your feet.\nYour field companion, from coast to canopy.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF60756A),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _hero(),
                          const SizedBox(height: 24),
                          _packCard(),
                          const SizedBox(height: 28),
                        ],
                        if (page == 0 || page == 1) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  page == 0
                                      ? 'Get to know the locals'
                                      : 'The field guide',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ),
                              if (page == 0)
                                TextButton(
                                  onPressed: () => setState(() => page = 1),
                                  child: const Text('Explore all'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Sample species · SDMyco collection coming soon',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF60756A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (page == 1) ...[
                            TextField(
                              onChanged: (v) => setState(() => query = v),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search common or scientific name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          LayoutBuilder(
                            builder: (context, constraints) => Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: filtered
                                  .map(
                                    (s) => SizedBox(
                                      width: constraints.maxWidth > 650
                                          ? (constraints.maxWidth - 28) / 3
                                          : (constraints.maxWidth - 14) / 2,
                                      child: _specimenCard(s),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          if (filtered.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'No sample species match that search.',
                              ),
                            ),
                        ],
                        if (page == 2) ...[
                          Text(
                            'Your little discoveries',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Keep a shortlist while you explore. Bookmarks in this design preview last until you close the app.',
                          ),
                          const SizedBox(height: 20),
                          if (saved.isEmpty)
                            _empty(
                              'A field notebook starts with curiosity.',
                              'Tap a bookmark on a species to keep it here.',
                            ),
                          ...specimens
                              .where((s) => saved.contains(s.latin))
                              .map(
                                (s) => ListTile(
                                  leading: const Icon(
                                    Icons.bookmark,
                                    color: coral,
                                  ),
                                  title: Text(s.common),
                                  subtitle: Text(s.latin),
                                  onTap: () => _openSpecimen(s),
                                ),
                              ),
                        ],
                        if (page == 3) ...[
                          Text(
                            'Ready for the wild?',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 20),
                          _packCard(),
                          const SizedBox(height: 20),
                          _empty(
                            'A little preparation. A lot of possibility.',
                            'Versioned collections, thumbnail downloads and storage checks are the next milestone. No field pack is downloaded yet.',
                          ),
                        ],
                        const SizedBox(height: 32),
                        const Divider(color: Color(0xFFDCDDCF)),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Icon(Icons.spa_outlined, size: 17, color: coral),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Look closely. Tread lightly. Stay curious.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF60756A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: paper,
        indicatorColor: const Color(0xFFE5E9D8),
        selectedIndex: page,
        onDestinationSelected: (v) => setState(() {
          page = v;
          query = '';
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Field guide',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            label: 'Notebook',
          ),
          NavigationDestination(
            icon: Icon(Icons.offline_bolt_outlined),
            label: 'Offline',
          ),
        ],
      ),
    );
  }

  Widget _hero() => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: ink,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -20,
          top: -30,
          child: Icon(
            Icons.filter_hdr,
            size: 240,
            color: Colors.white.withValues(alpha: .05),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'THE WORLD IS FULL OF FUNGI',
                      style: TextStyle(
                        color: Color(0xFFC5D7A8),
                        fontSize: 9,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Found a fun guy?',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        color: paper,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start with a closer look.',
                      style: TextStyle(color: Color(0xFFD3DFCF), fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFEDC484),
                        foregroundColor: ink,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () => explain(
                        'A future “Fungi!” moment',
                        'Camera capture and on-device mushroom detection are planned. Once a mushroom is detected, FunGuy will celebrate with “Fungi!” and offer possible matches, an unknown result, and a way to record your find.\n\nNo camera or identification model is connected in this preview.',
                      ),
                      icon: const Icon(Icons.camera_alt_outlined, size: 19),
                      label: const Text('Meet a mushroom'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const MushroomArt(size: 100),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _packCard() => InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: () => explain(
      'Take the woods with you',
      'Planned: download SDMyco observation metadata and permitted thumbnails before a hike. A pack will only show “Ready offline” after every required file is verified.\n\nThis preview includes illustrative species cards. The SDMyco field pack is not yet available.',
    ),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECDf),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDCE2CF)),
      ),
      child: const Row(
        children: [
          Icon(Icons.download_for_offline_outlined, color: ink, size: 30),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A field guide, beyond the signal',
                  style: TextStyle(
                    color: ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'San Diego collection · in the making',
                  style: TextStyle(fontSize: 11, color: Color(0xFF60756A)),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, size: 18, color: ink),
        ],
      ),
    ),
  );
  Widget _empty(String title, String message) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: const Color(0xFFE9ECDF),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      children: [
        Image.asset(
          'assets/brand/tlatoani-field-reference.png',
          height: 180,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
      ],
    ),
  );
  Widget _specimenCard(Specimen s) => Material(
    color: const Color(0xFFFFFDF6),
    borderRadius: BorderRadius.circular(18),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => _openSpecimen(s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.25,
                child: SpecimenIllustration(kind: s.common),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton.filledTonal(
                  style: IconButton.styleFrom(backgroundColor: paper),
                  iconSize: 18,
                  onPressed: () => setState(() {
                    saved.contains(s.latin)
                        ? saved.remove(s.latin)
                        : saved.add(s.latin);
                  }),
                  tooltip: saved.contains(s.latin)
                      ? 'Remove bookmark'
                      : 'Bookmark species',
                  icon: Icon(
                    saved.contains(s.latin)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: ink,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.common,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 20,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.latin,
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF60756A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'SPECIES PREVIEW',
                  style: TextStyle(
                    fontSize: 8,
                    letterSpacing: 1.3,
                    color: coral,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  void _openSpecimen(Specimen s) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: paper,
    builder: (context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: SpecimenIllustration(kind: s.common),
              ),
            ),
            const SizedBox(height: 20),
            Text(s.common, style: Theme.of(context).textTheme.headlineMedium),
            Text(s.latin, style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text(s.habitat),
            const SizedBox(height: 16),
            const Text(
              'Illustrative species card, not a verified SDMyco observation. The drawings are decorative, not diagnostic reference photos. Community identification and DNA evidence will be shown independently on imported observations.',
            ),
            const SizedBox(height: 20),
            Text(
              '“This looks like…”',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Planned comparison: similar reference photos, visible traits, location and season when available, and what is still unknown. No model has analyzed a photo in this preview.',
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Visual clues')),
                Chip(label: Text('Similar specimens')),
                Chip(label: Text('Evidence & uncertainty')),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'A photo match is a starting point for study. Never use it to decide whether a mushroom is safe to eat.',
              style: TextStyle(fontSize: 12, color: Color(0xFF87523A)),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep exploring'),
            ),
          ],
        ),
      ),
    ),
  );
}

class MushroomArt extends StatelessWidget {
  final double size;
  const MushroomArt({super.key, required this.size});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Illustrated mushroom',
    child: CustomPaint(
      size: Size(size, size * 1.2),
      painter: _MushroomPainter(),
    ),
  );
}

class _MushroomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    canvas.save();
    canvas.scale(size.width / 100, size.height / 120);
    canvas.drawOval(
      const Rect.fromLTWH(12, 107, 80, 9),
      p..color = const Color(0xFF0E2D27),
    );
    canvas.drawPath(
      Path()
        ..moveTo(44, 49)
        ..quadraticBezierTo(46, 79, 36, 106)
        ..quadraticBezierTo(51, 116, 66, 106)
        ..quadraticBezierTo(57, 78, 59, 49)
        ..close(),
      p..color = const Color(0xFFF2DFB5),
    );
    canvas.drawPath(
      Path()
        ..moveTo(4, 53)
        ..cubicTo(10, -3, 82, -9, 97, 53)
        ..quadraticBezierTo(52, 73, 4, 53)
        ..close(),
      p..color = coral,
    );
    canvas.drawOval(
      const Rect.fromLTWH(4, 49, 93, 16),
      p..color = const Color(0xFFEDBD8D),
    );
    for (final spot in [
      const Rect.fromLTWH(23, 25, 13, 8),
      const Rect.fromLTWH(54, 11, 11, 8),
      const Rect.fromLTWH(71, 32, 14, 8),
      const Rect.fromLTWH(43, 35, 9, 6),
    ]) {
      canvas.drawOval(spot, p..color = const Color(0xFFF7E8CF));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SpecimenIllustration extends StatelessWidget {
  final String kind;
  const SpecimenIllustration({super.key, required this.kind});
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: kind == 'Fly agaric'
        ? const Color(0xFFDFE7DD)
        : kind == 'Turkey tail'
        ? const Color(0xFFE9DFCE)
        : const Color(0xFFF0E5CA),
    child: Stack(
      children: [
        Positioned(
          right: 12,
          top: 12,
          child: Text(
            'ILLUSTRATION',
            style: TextStyle(
              fontSize: 7,
              letterSpacing: 1.6,
              color: ink.withValues(alpha: .55),
            ),
          ),
        ),
        Center(
          child: FractionallySizedBox(
            widthFactor: .7,
            heightFactor: .8,
            child: CustomPaint(painter: _SpecimenPainter(kind)),
          ),
        ),
      ],
    ),
  );
}

class _SpecimenPainter extends CustomPainter {
  final String kind;
  _SpecimenPainter(this.kind);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 160, size.height / 150);
    final p = Paint()..color = const Color(0xFFCCD2BC);
    canvas.drawOval(const Rect.fromLTWH(17, 132, 132, 8), p);
    if (kind == 'Turkey tail') {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(20, 88, 125, 37),
          const Radius.circular(12),
        ),
        p..color = const Color(0xFF7B6450),
      );
      for (int j = 0; j < 3; j++) {
        canvas.save();
        canvas.translate(35 + j * 30.0, 49 + j * 15.0);
        canvas.rotate((j - 1) * .25);
        final shape = Path()
          ..moveTo(20, 55)
          ..cubicTo(-50, 20, -4, -15, 24, 6)
          ..cubicTo(70, -16, 90, 33, 20, 55)
          ..close();
        canvas.drawPath(shape, p..color = const Color(0xFFEEDBB8));
        for (int i = 0; i < 4; i++) {
          canvas.save();
          canvas.translate(20, 50);
          canvas.scale(1 - i * .18);
          canvas.translate(-20, -50);
          canvas.drawPath(
            shape,
            p
              ..color = [
                const Color(0xFF72594C),
                const Color(0xFFB6936B),
                const Color(0xFFD7BE98),
                const Color(0xFF6C7770),
              ][i],
          );
          canvas.restore();
        }
        canvas.restore();
      }
    } else if (kind == 'Chanterelle') {
      for (int j = 0; j < 3; j++) {
        canvas.save();
        canvas.translate(19 + j * 44.0, 30 + (j % 2) * 15.0);
        canvas.rotate((j - 1) * .18);
        canvas.drawPath(
          Path()
            ..moveTo(22, 47)
            ..lineTo(17, 104)
            ..quadraticBezierTo(27, 110, 33, 101)
            ..lineTo(34, 47)
            ..close(),
          p..color = const Color(0xFFD99539),
        );
        canvas.drawPath(
          Path()
            ..moveTo(-9, 24)
            ..quadraticBezierTo(1, 7, 16, 20)
            ..quadraticBezierTo(29, 0, 43, 18)
            ..quadraticBezierTo(74, 7, 61, 32)
            ..quadraticBezierTo(35, 72, -9, 24)
            ..close(),
          p..color = const Color(0xFFE8B65A),
        );
        canvas.drawOval(
          const Rect.fromLTWH(9, 22, 35, 12),
          p..color = const Color(0xFFC48537),
        );
        canvas.restore();
      }
    } else {
      canvas.translate(25, 7);
      canvas.scale(1.1, 1.05);
      _MushroomPainter().paint(canvas, const Size(100, 120));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SpecimenPainter oldDelegate) =>
      oldDelegate.kind != kind;
}
