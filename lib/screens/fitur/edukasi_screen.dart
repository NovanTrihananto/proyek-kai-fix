import 'package:flutter/material.dart';
import '/constants/colors.dart'; // Pastikan path ini benar
import '/routes.dart'; // Impor routes.dart agar Routes.noisense bisa diakses

class EdukasiScreen extends StatelessWidget {
  const EdukasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edukasi Kebisingan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEdukasiHeader(),
            const SizedBox(height: 20),
            _buildSectionTitle('1. Kenali Batas Aman Desibelmu!'),
            _buildDesibelInfo(context),
            const SizedBox(height: 20),
            _buildSectionTitle('2. Lindungi Telingamu dengan APD!'),
            _buildAPDInfo(context),
            const SizedBox(height: 20),
            _buildSectionTitle('3. Jangan Anggap Remeh: Dampak Kebisingan!'),
            _buildDampakInfo(context),
            const SizedBox(height: 20),
            _buildCallToAction(context),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                '📄 Informasi dalam halaman ini mengacu pada:\nPermenakertrans No. PER.13/MEN/X/2011\nTentang Nilai Ambang Batas Faktor Fisika di Tempat Kerja',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEdukasiHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suara Bising? Bahaya Mengintai!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pelajari bagaimana kebisingan bisa merusak telingamu dan cara melindunginya.',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/edukasi/peringatan.png',
              fit: BoxFit.contain,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildDesibelInfo(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apa Itu Desibel (dB)?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Desibel adalah satuan untuk mengukur intensitas suara. Semakin tinggi angkanya, semakin keras suaranya!',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15),
            Image.asset(
              'assets/edukasi/chart.png',
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 10),
            const Text(
              'Penting: Paparan kebisingan di atas 85 dB (setara suara lalu lintas padat) dalam jangka panjang bisa merusak pendengaranmu!',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Sumber: Permenakertrans No. PER.13/MEN/X/2011 tentang Nilai Ambang Batas Faktor Fisika di Tempat Kerja.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAPDInfo(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alat Pelindung Diri (APD) untuk Telinga',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Saat berada di lingkungan bising, gunakan APD pendengaran untuk melindungi telingamu. Ada beberapa jenis, lho:',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            _buildAPDItem(
              'Penyumbat Telinga (Earplugs)',
              'assets/edukasi/earplug.jpg',
              'Kecil, praktis, dan efektif untuk mengurangi kebisingan sedang. Cocok untuk konser atau bekerja dengan mesin yang tidak terlalu bising.',
            ),
            _buildAPDItem(
              'Penutup Telinga (Earmuffs)',
              'assets/edukasi/earmuff.jpg',
              'Lebih besar dan mampu meredam suara lebih kuat. Ideal untuk lingkungan dengan kebisingan sangat tinggi, seperti di dekat pesawat atau mesin industri.',
            ),
            const SizedBox(height: 10),
            const Text(
              'Selalu pastikan APD terpasang dengan benar untuk perlindungan maksimal!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Sumber: Permenakertrans No. PER.13/MEN/X/2011 – Pasal 5 dan 6 mengenai kewajiban penyediaan dan penggunaan APD di lingkungan kerja bising.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAPDItem(String name, String iconPath, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(iconPath, width: 40, height: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(description, textAlign: TextAlign.justify),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDampakInfo(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apa Akibatnya Jika Terpapar Kebisingan?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kebisingan tidak hanya membuat telinga sakit, tapi juga bisa berdampak serius pada kesehatanmu:',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            _buildDampakListItem(Icons.hearing_disabled, 'Kerusakan Pendengaran Permanen'),
            _buildDampakListItem(Icons.headset_off, 'Tinnitus (Telinga Berdenging)'),
            _buildDampakListItem(Icons.mood_bad, 'Stres dan Gangguan Tidur'),
            _buildDampakListItem(Icons.health_and_safety, 'Peningkatan Risiko Penyakit Jantung'),
            _buildDampakListItem(Icons.accessibility_new, 'Gangguan Konsentrasi dan Produktivitas'),
            const SizedBox(height: 10),
            const Text(
              'Jaga pendengaranmu, karena sekali rusak, sulit untuk pulih sepenuhnya!',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Sumber: Permenakertrans No. PER.13/MEN/X/2011 – Lampiran penjelasan risiko kebisingan terhadap kesehatan pekerja.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDampakListItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildCallToAction(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Column(
        children: [
          Text(
            'Ingat: Pencegahan Lebih Baik Daripada Mengobati!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gunakan aplikasi NoiSense untuk mengetahui tingkat kebisingan di sekitarmu dan lindungi pendengaranmu!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, Routes.noisense);
            },
            icon: const Icon(Icons.wifi_tethering),
            label: const Text('Cek Kebisingan Sekarang!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
