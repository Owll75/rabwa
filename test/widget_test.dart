import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabwa/theme.dart';

void main() {
  group('RiverThemeDarkModel', () {
    test('Initial state is false', () {
      // Arrange
      final model = RiverThemeDarkModel();

      // Act & Assert
      expect(model.isDark, false);
    });

    test('Toggling dark mode updates the state', () {
      // Arrange
      final model = RiverThemeDarkModel();

      // Act
      model.toggleDark();

      // Assert
      expect(model.isDark, true);

      // Act
      model.toggleDark();

      // Assert
      expect(model.isDark, false);
    });

    test('Setting isDark updates the state', () {
      // Arrange
      final model = RiverThemeDarkModel();

      // Act
      model.isDark = true;

      // Assert
      expect(model.isDark, true);

      // Act
      model.isDark = false;

      // Assert
      expect(model.isDark, false);
    });
  });
}
