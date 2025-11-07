import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ⭐️ Wajib di-import

// ----------------------------------------------------
// 1. RIVERPOD STATE DEFINITION
// ----------------------------------------------------

// Definisikan StateProvider untuk menyimpan nilai counter.
// Ini menggantikan 'int _counter = 0;' di StatefulWidget.
final counterProvider = StateProvider<int>((ref) {
  return 0; // Nilai awal
});

// ----------------------------------------------------
// 2. MAIN APP SETUP
// ----------------------------------------------------

void main() {
  // ⭐️ WAJIB: Bungkus MyApp dengan ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // MyHomePage sekarang akan menjadi ConsumerWidget (tidak perlu diubah)
      home: const MyHomePage(title: 'Sahrul Aripiansyah'),
      color: Colors.white,
    );
  }
}

// ----------------------------------------------------
// 3. HOME PAGE (CONSUMERWIDGET)
// ----------------------------------------------------

// ⭐️ Ganti StatefulWidget menjadi ConsumerWidget dari Riverpod
class MyHomePage extends ConsumerWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  // ⭐️ ConsumerWidget memerlukan WidgetRef ref di method build
  Widget build(BuildContext context, WidgetRef ref) {
    // ⭐️ Ambil nilai counter dari provider (Ref.watch akan merefresh UI saat state berubah)
    final counter = ref.watch(counterProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white, //warna teks appBar
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // ⭐️ Body untuk Gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 97, 250, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 97, 250, 255),
            ],
          ),
        ),

        child: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            elevation: 0, // Hapus bayangan agar terlihat rata
            color: Colors.transparent, // Card harus transparan
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            // Konten diletakkan di tengah dan dibungkus Card
            // ⭐️ CHILD DIBUNGKUS DENGAN CONTAINER BARU UNTUK GRADIENT
            child: Container(
              // Tambahkan gradient yang berbeda di sini
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ), // Harus sama dengan Card
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 91, 255, 58),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
              ),

              // Pindahkan Padding dan Column (Konten Card) ke dalam Container ini
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // ... (Semua konten Ikon, Text, dan Angka)
                    const Icon(
                      Icons.analytics,
                      size: 60,
                      // Ubah warna ikon agar kontras dengan gradient Card
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Anda telah menekan tombol sebanyak:',
                      textAlign: TextAlign.center,
                      // Ubah warna teks agar kontras dengan gradient Card
                      style: TextStyle(color: Colors.black),
                    ),
                    // Menampilkan nilai dari Riverpod State
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 300,
                      ), // Kecepatan animasi
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            // Memberikan efek skala/lonjakan
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                      child: Text(
                        '$counter',
                        key: ValueKey<int>(
                          counter,
                        ), // ⭐️ KEY WAJIB ADA dan unik!
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF330066),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tombol Decrement
          FloatingActionButton(
            heroTag: "decrement",
            onPressed: () {
              // ⭐️ Mengubah state Riverpod: ref.read(provider.notifier).update(...)
              ref.read(counterProvider.notifier).update((state) => state - 1);
            },
            tooltip: 'Kurangi',
            child: const Icon(Icons.remove),
          ),

          const SizedBox(width: 16),
          // Tombol Increment
          FloatingActionButton(
            heroTag: "increment",
            onPressed: () {
              // ⭐️ Mengubah state Riverpod: ref.read(provider.notifier).update(...)
              ref.read(counterProvider.notifier).update((state) => state + 1);
            },
            tooltip: 'Tambah',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
