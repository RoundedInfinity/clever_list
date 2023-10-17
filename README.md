# Clever List

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A ListView widget that implicitly animates changes. CleverLists are built from a list of data objects.

## Usage 

Using CleverList is straightforward. You need to create a list of items, define a builder function for rendering each item, and specify optional animations for insertion and removal.

First you need data for your list. The list uses the `==` operator to compare them. You can also set your own comparison by using `equalityChecker`.

```dart
// Your data that you want to use to build the list.
var persons = <String>[
  'Rick',
  'Beth',
  'Jerry'
];
```

Then you can use this data for your widget.

```dart
CleverList<String>(
  items: persons,
  builder: (context, value) {
    return ListTile(
      title: Text(value),
    );
  },
)
```

Now when `persons` changes and the state is updated, the list will automatically animate the changes.

### Customization 

Use `insertDuration` and `removeDuration` to customize the durations for the insert and remove durations.

You can use the insertTransitionBuilder and removeTransitionBuilder parameters to create your custom insertion and removal animations.

For more advanced use cases, you can extend  `CleverListBase` or `CleverListWidget` for your own implementation.


## Acknowledgements

This package is greatly inspired by [diffutil_sliverlist]([https://](https://pub.dev/packages/diffutil_sliverlist)) ❤️.

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
