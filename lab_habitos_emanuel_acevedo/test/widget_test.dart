import 'package:flutter_test/flutter_test.dart';
import 'package:practica1/main.dart';

void main() {
  testWidgets('Course detail screen shows the required content', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Detalle del curso'), findsOneWidget);
    expect(find.text('Introducción al Desarrollo Móvil'), findsOneWidget);
    expect(find.text('Docente: Emanuel Acevedo'), findsOneWidget);
    expect(find.text('18 semanas'), findsOneWidget);
    expect(find.text('Nivel: Intermedio'), findsOneWidget);
    expect(find.text('Inscribirme'), findsOneWidget);
  });
}
