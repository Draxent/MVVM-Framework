[← Back](./README.md)

# Integrated Feature

The Integrated feature shows how to use a nesting of MVVM components and how to interact with them. It demonstrates integrating multiple MVVM-based components, such as counter and restaurants features, into a single cohesive application while maintaining clear separation of concerns and interaction between the components.

This feature allows users to interact with both the counter and restaurants functionalities in a unified interface. Users can update and submit counter values, toggle user location updates, and view a list of restaurants based on their location. It showcases how different MVVM components can work together seamlessly while preserving their individual responsibilities.

<img src='../doc/integrated.gif' width='40%'>

---

## Code

### Model

The `IntegratedModel` represents the state of the integrated features, including the counter and user location.

```dart
@freezed
abstract class IntegratedModel with _$IntegratedModel implements Model {
  const factory IntegratedModel({
    @Default(0) int counterInitialInputValue,
    @Default(0) int counterInputValue,
    @Default(0) int counterSubmittedValue,
    @Default(true) bool isUserLocationPaused,
```

- **`counterInitialInputValue`**: Stores the initial value for the input text field.
- **`counterInputValue`**: Tracks the current value entered by the user for the counter.
- **`counterSubmittedValue`**: Tracks the last submitted counter value.
- **`isUserLocationPaused`**: Indicates whether user location updates are paused.

---

### ViewModel

The `IntegratedVM` contains the business logic for managing the counter and user location.

#### Update input value logic

```dart
void updateCounterInputValue(int value) => emit(state.copyWith(counterInputValue: value));
```

It updates the `counterInputValue` in the state when the user enter a value on the text field.


---

### View

The `IntegratedPageView` provides the UI for interacting with both the counter and restaurants features.

#### Input counter

```dart
Widget build(BuildContext context) {
  final initialValue = select(context, (vm) => vm.state.counterInitialInputValue.toString());
  return Row(
    children: [
      Expanded(
        child: TextFormField(
          key: ValueKey(initialValue),
          initialValue: initialValue,
          decoration: const InputDecoration(labelText: 'Counter Value'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final intValue = int.tryParse(value) ?? 0;
            vm(context).updateCounterInputValue(intValue);
          },
        ),
      ),
```

- It uses the `counterInitialInputValue` as both the initial value and a unique key for the `TextFormField`, ensuring the widget is rebuilt correctly when the initial value changes.
- It updates the `counterInputValue` in the `ViewModel` whenever the user changes the text field value.

---

## Testing

The Integrated feature includes unit and widget tests to ensure its functionality.

### Unit Tests

Unit tests verify the business logic in the `IntegratedVM` class.

```dart
test('should update counter input value', () {
  const newValue = 5;
  uut.updateCounterInputValue(newValue);
  expect(uut.state.counterInputValue, newValue);
});
```

It ensures that the method correctly updates the `counterInputValue` in the state when a new value is provided.

### Widget Tests

Widget tests ensure the UI behaves as expected.

```dart
testWidgets('should update counter input value when text field changes', (tester) async {
  await tester.pumpWidget(uut);
  final textField = find.byType(TextField);
  expect(textField, findsOneWidget);
  await tester.enterText(textField, '5');
  await tester.pump();
  verify(vm.updateCounterInputValue(5)).called(1);
});
```

It ensures that the `updateCounterInputValue` method is called with the correct value when the text field changes.
