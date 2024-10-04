import 'dart:io';
import 'dart:math';
import 'dart:async';

final random = Random();
final console = stdout;  // Stdout digunakan untuk print di terminal
final int width = stdout.terminalColumns;
final int height = stdout.terminalLines;

void main() async {
  // Set awal background hitam
  console.write("\x1B[40m\x1B[2J"); // Clear screen dan atur background hitam
  
  stdout.write('Masukkan jumlah kembang api: ');
  int numberOfFireworks = int.parse(stdin.readLineSync()!);

  for (int i = 0; i < numberOfFireworks; i++) {
    // Titik awal peluru kembang api di bawah layar
    int startX = random.nextInt(width);
    int startY = height - 2;

    // Tentukan target ledakan berdasarkan posisi peluru terakhir
    int targetX = startX;
    int targetY;

    // Untuk kembang api pertama, meledak di tengah layar
    if (i == 0) {
      targetX = width ~/ 2;
      targetY = height ~/ 2;
    } else {
      // Kembang api selanjutnya meledak di posisi yang ditentukan oleh peluru
      targetY = random.nextInt(height ~/ 2) + 2; // Supaya meledak di atas
    }

    // Gerakkan peluru dan ledakkan di posisi target
    await animateFirework(startX, startY, targetX, targetY);
    sleep(Duration(seconds: 2)); // Jeda 2 detik sebelum kembang api berikutnya
  }

  // Tampilkan pesan HBD ANO setelah semua kembang api selesai
  await showHBDANO(width, height);

  // Kembalikan terminal ke kondisi normal tanpa warna background setelah selesai
  console.write("\x1B[0m\x1B[2J"); // Reset attributes dan clear screen
}

Future<void> animateFirework(int startX, int startY, int targetX, int targetY) async {
  // Pilih warna acak untuk kembang api
  String color = getRandomColor();

  // Simulasi peluru kecil bergerak ke atas
  for (int y = startY; y > targetY; y--) {
    clearScreen();
    moveToPosition(startX, y);
    console.write("$color*\x1B[0m"); // Titik kecil sebagai peluru
    await Future.delayed(Duration(milliseconds: 50)); // Animasi bergerak ke atas
  }

  // Ketika mencapai target, buat ledakan berbentuk bunga segi enam
  displayHexagonalExplosion(targetX, targetY, color);
}

void displayHexagonalExplosion(int x, int y, String color) {
  // Ubah background sesuai warna kembang api
  changeBackgroundColor(color);

  clearScreen();
  
  // Ledakan bentuk bunga segi enam
  moveToPosition(x, y);
  console.write("$color*\x1B[0m"); // Titik pusat

  // Enam titik sekeliling membentuk segi enam
  moveToPosition(x + 2, y);     // Kanan
  console.write("$color*\x1B[0m");

  moveToPosition(x - 2, y);     // Kiri
  console.write("${color}*\x1B[0m");

  moveToPosition(x + 1, y + 1); // Kanan bawah
  console.write("${color}*\x1B[0m");

  moveToPosition(x - 1, y + 1); // Kiri bawah
  console.write("${color}*\x1B[0m");

  moveToPosition(x + 1, y - 1); // Kanan atas
  console.write("${color}*\x1B[0m");

  moveToPosition(x - 1, y - 1); // Kiri atas
  console.write("${color}*\x1B[0m");

  sleep(Duration(milliseconds: 300)); // Tahan ledakan di layar sejenak
}

void clearScreen() {
  console.write("\x1B[2J"); // Clear screen
}

void moveToPosition(int x, int y) {
  console.write("\x1B[${y};${x}H"); // Pindah ke posisi (x, y) di terminal
}

String getRandomColor() {
  List<String> colors = [
    "\x1B[31m", // Red
    "\x1B[32m", // Green
    "\x1B[33m", // Yellow
    "\x1B[34m", // Blue
    "\x1B[35m", // Magenta
    "\x1B[36m", // Cyan
  ];
  return colors[random.nextInt(colors.length)];
}

void changeBackgroundColor(String color) {
  // Ganti warna background sesuai dengan warna kembang api
  if (color == "\x1B[31m") {
    console.write("\x1B[41m"); // Background merah
  } else if (color == "\x1B[32m") {
    console.write("\x1B[42m"); // Background hijau
  } else if (color == "\x1B[33m") {
    console.write("\x1B[43m"); // Background kuning
  } else if (color == "\x1B[34m") {
    console.write("\x1B[44m"); // Background biru
  } else if (color == "\x1B[35m") {
    console.write("\x1B[45m"); // Background magenta
  } else if (color == "\x1B[36m") {
    console.write("\x1B[46m"); // Background cyan
  }
}

Future<void> showHBDANO(int terminalWidth, int terminalHeight) async {
  // Clear screen and set background to default
  stdout.write("\x1B[2J\x1B[0m");

  // Define HBD ANO in a large size using stars
  List<String> hbdano = [
    "H     H  BBBBBB   DDDDD         A     N     N  ******",
    "H     H  B     B  D    D       A A    N N   N  *    *",
    "HHHHHHH  BBBBBB   D     D     AAAAA   N  N  N  *    *",
    "H     H  B     B  D    D     A     A  N   N N  *    *",
    "H     H  BBBBBB   DDDDD     A       A N     N  ******"
  ];

  // Center the text vertically
  int startRow = terminalHeight - 1;
  int positionCol = (terminalWidth ~/ 2) - (hbdano[0].length ~/ 2);

  // Move the text upwards
  for (int row = startRow; row >= 0; row--) {
    clearScreen();
    for (int i = 0; i < hbdano.length; i++) {
      int currentRow = row + i;
      if (currentRow >= 0 && currentRow < terminalHeight) {
        moveToPosition(positionCol, currentRow);
        stdout.writeln(hbdano[i]);
      }
    }
    await Future.delayed(Duration(milliseconds: 200));
  }

  // Clear the screen after the animation
  stdout.write("\x1B[2J\x1B[0m");
}
