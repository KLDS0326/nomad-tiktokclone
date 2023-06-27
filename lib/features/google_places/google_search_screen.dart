import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/google_map/Widgets/marker_icons.dart';
import 'package:tiktok_clone/features/google_places/google_search_main_home.dart';

import 'package:tiktok_clone/features/google_places/widgets/constants.dart';

/// Title
const title = '지역 검색';

/// Main app
class GoogleSearchScreen extends StatelessWidget {
  const GoogleSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: const GoogleSearch(),
    );
  }
}

/// Main home page
class GoogleSearch extends StatefulWidget {
  const GoogleSearch({super.key});

  @override
  State<StatefulWidget> createState() => _GoogleSearchPageState();
}

class _GoogleSearchPageState extends State<GoogleSearch> {
  late final FlutterGooglePlacesSdk _places;

  //
  String? _predictLastText;

  final PlaceTypeFilter _placeTypeFilter = PlaceTypeFilter.REGIONS;

  final bool _locationBiasEnabled = true;
  final LatLngBounds _locationBias = const LatLngBounds(
      southwest: LatLng(lat: 32.0810305, lng: 34.785707),
      northeast: LatLng(lat: 32.0935937, lng: 34.8013896));

  final bool _locationRestrictionEnabled = false;
  final LatLngBounds _locationRestriction = const LatLngBounds(
      southwest: LatLng(lat: 32.0583974, lng: 34.7633473),
      northeast: LatLng(lat: 32.0876885, lng: 34.8040563));

  final List<String> _countries = ['kr'];
  final bool _countriesEnabled = true;

  bool _predicting = false;
  dynamic _predictErr;

  List<AutocompletePrediction>? _predictions;

  //
  final TextEditingController _fetchPlaceIdController = TextEditingController();
  final TextEditingController _searchWordController = TextEditingController();
  final List<PlaceField> _placeFields = [
    PlaceField.Address,
    PlaceField.AddressComponents,
    PlaceField.BusinessStatus,
    PlaceField.Id,
    PlaceField.Location,
    PlaceField.Name,
    PlaceField.OpeningHours,
    PlaceField.PhoneNumber,
    PlaceField.PhotoMetadatas,
    PlaceField.PlusCode,
    PlaceField.PriceLevel,
    PlaceField.Rating,
    PlaceField.Types,
    PlaceField.UserRatingsTotal,
    PlaceField.UTCOffset,
    PlaceField.Viewport,
    PlaceField.WebsiteUri,
  ];

  bool _fetchingPlace = false;
  dynamic _fetchingPlaceErr;

  Place? _place;
  bool _isWriting = false;

  final MarkerIconsPage _markerIconsPage =
      const MarkerIconsPage(latitude: 0.0, longitude: 0.0);

  @override
  void initState() {
    super.initState();

    _places = FlutterGooglePlacesSdk(INITIAL_API_KEY, locale: INITIAL_LOCALE);
    _places.isInitialized().then((value) {
      debugPrint('Places Initialized: $value');
    });
  }

  void _onClearTap() {
    _searchWordController.clear();
  }

  void _onClosePressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final predictionsWidgets = _buildPredictionWidgets();
    final fetchPlaceWidgets = _buildFetchPlaceWidgets();
    final mapCreateWidgets = _buildMapCreationWidgets();
    final confirmWidgets = _buildConfirmWidgets();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(title),
        actions: [
          IconButton(
            onPressed: () => _onClosePressed(context),
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _stopWriting,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: ListView(
                  children: predictionsWidgets +
                      [
                        const SizedBox(height: 16),
                      ] +
                      fetchPlaceWidgets +
                      [
                        const SizedBox(height: 16),
                      ] +
                      mapCreateWidgets +
                      [
                        const SizedBox(height: 16),
                      ] +
                      confirmWidgets,
                ),
              ),
            ),
            /*  Expanded(
                child: Column(
              children: [
                MarkerIconsPage(
                  latitude: _place?.latLng?.lat ?? 0.0,
                  longitude: _place?.latLng?.lng ?? 0.0,
                ),
                //_markerIconsPage,
      
                /* MarkerIconsPage(
                  latitude: _place?.latLng?.lat ?? 0.0,
                  longitude: _place?.latLng?.lng ?? 0.0,
                ), */
              ],
            )), */
          ],
        ),
      ),
    );
  }

  void _onPredictTextChanged(String value) {
    _predictLastText = value;
    /* if (_predictLastText != null) {
      if (_predictLastText!.length >= 2) {
        _predict();
      }
    } */
  }

  void _fetchPlace() async {
    if (_fetchingPlace) {
      return;
    }

    final text = _fetchPlaceIdController.text;
    final hasContent = text.isNotEmpty;

    setState(() {
      _fetchingPlace = hasContent;
      _fetchingPlaceErr = null;
    });

    if (!hasContent) {
      return;
    }

    try {
      final result = await _places.fetchPlace(_fetchPlaceIdController.text,
          fields: _placeFields);

      setState(
        () {
          _place = result.place;
          _fetchingPlace = false;
        },
      );
    } catch (err) {
      setState(() {
        _fetchingPlaceErr = err;
        _fetchingPlace = false;
      });
    }
  }

  void _predict() async {
    if (_predicting) {
      return;
    }

    final hasContent = _predictLastText?.isNotEmpty ?? false;

    setState(() {
      _predicting = hasContent;
      _predictErr = null;
    });

    if (!hasContent) {
      return;
    }

    try {
      final result = await _places.findAutocompletePredictions(
        _predictLastText!,
        countries: _countries,
        placeTypeFilter: _placeTypeFilter,
        newSessionToken: false,
        origin: const LatLng(lat: 43.12, lng: 95.20),
        locationBias: _locationBiasEnabled ? _locationBias : null,
        locationRestriction:
            _locationRestrictionEnabled ? _locationRestriction : null,
      );

      setState(() {
        _predictions = result.predictions;
        _predicting = false;
      });
    } catch (err) {
      setState(() {
        _predictErr = err;
        _predicting = false;
      });
    }
  }

  void _onItemClicked(AutocompletePrediction item) {
    _fetchPlaceIdController.text = item.placeId;
    _fetchPlace();
  }

  void _confirmButton(BuildContext context) {
    print(_place?.address); //null
    print(_place?.address ?? ''); // ''

    showModalBottomSheet(
      context: context,
      builder: (context) => const GoogleSearchMainHome(),
    );
  }

  Widget _buildPredictionItem(AutocompletePrediction item) {
    return InkWell(
      onTap: () => _onItemClicked(item),
      child: Column(children: [
        Text(item.fullText.substring(4)),
        const Divider(thickness: 2),
      ]),
    );
  }

  Widget _buildErrorWidget(dynamic err) {
    final theme = Theme.of(context);
    final errorText = err == null ? '' : err.toString();
    return Text(errorText,
        style: theme.textTheme.bodySmall
            ?.copyWith(color: theme.colorScheme.error));
  }

  List<Widget> _buildFetchPlaceWidgets() {
    return [
      // --
      /* TextFormField(controller: _fetchPlaceIdController),
      ElevatedButton(
        onPressed: _fetchingPlace == true ? null : _fetchPlace,
        child: const Text('Fetch Place'),
      ), */

      // -- Error widget + Result
      _buildErrorWidget(_fetchingPlaceErr),
//      WebSelectableText('Result: ${_place?.toString() ?? 'N/A'}'),
      WebSelectableText('Result: ${_place?.latLng ?? ''}'),
      WebSelectableText('Result: ${_place?.address ?? ''}'),
    ];
  }

  List<Widget> _buildMapCreationWidgets() {
    return [
      MarkerIconsPage(
        latitude: _place?.latLng?.lat ?? 0.0,
        longitude: _place?.latLng?.lng ?? 0.0,
        key: UniqueKey(),
      )
    ];
  }

  List<Widget> _buildConfirmWidgets() {
    return [
      ElevatedButton(
        onPressed: () => _confirmButton(context),
        child: const Text('확인',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Sizes.size16,
            )),
      ),
    ];
  }

  List<Widget> _buildPredictionWidgets() {
    return [
      // --
      Row(
        children: [
          Expanded(
            child: TextFormField(
              onTap: _onStartWriting,
              cursorColor: Theme.of(context).primaryColor,
              /* decoration: InputDecoration(
                hintText: "작성하세요 댓글",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Sizes.size12,
                  ),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size12,
                  vertical: Sizes.size10,
                ),
              ), */
              controller: _searchWordController,
              onChanged: _onPredictTextChanged,
              decoration: InputDecoration(
                hintText: "지역을 검색하세요",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Sizes.size12,
                  ),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size12,
                  vertical: Sizes.size10,
                ),
                /* label: const Text("검색"),
                icon: const FaIcon(
                  FontAwesomeIcons.solidFaceLaughWink,
                ), */
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _onClearTap,
                      child: FaIcon(
                        FontAwesomeIcons.solidCircleXmark,
                        color: Colors.grey.shade500,
                        size: Sizes.size20,
                      ),
                    ),
                    Gaps.h12,
                    /* 
                    GestureDetector(
                      onTap: _predict,
                      child: const Icon(Icons.search),
                    ) */
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _predict,
            child: const Icon(Icons.search, size: Sizes.size28),
          )
        ],
      ),

      // -- Error widget + Result
      _buildErrorWidget(_predictErr),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: (_predictions ?? [])
            .map(_buildPredictionItem)
            .toList(growable: false),
      ),
      const Image(
        image: FlutterGooglePlacesSdk.ASSET_POWERED_BY_GOOGLE_ON_WHITE,
      ),
    ];
  }
}

/// Callback function with LatLngBounds
typedef void ActionWithBounds(LatLngBounds);

/// Location widget used to display and edit a LatLngBounds type
class LocationField extends StatefulWidget {
  /// Label associated with this field
  final String label;

  /// If true the field is enabled. If false it is disabled and user can not interact with it
  /// Value is retained even when the field is disabled
  final bool enabled;

  /// The current value in the field
  final LatLngBounds value;

  /// Callback for when the value has changed by the user.
  final ActionWithBounds onChanged;

  /// Create a LocationField
  const LocationField(
      {Key? key,
      required this.label,
      required this.enabled,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  late TextEditingController _ctrlNeLat;
  late TextEditingController _ctrlNeLng;
  late TextEditingController _ctrlSwLat;
  late TextEditingController _ctrlSwLng;

  @override
  void initState() {
    super.initState();

    _ctrlNeLat = TextEditingController.fromValue(
        TextEditingValue(text: widget.value.northeast.lat.toString()));
    _ctrlNeLng = TextEditingController.fromValue(
        TextEditingValue(text: widget.value.northeast.lng.toString()));
    _ctrlSwLat = TextEditingController.fromValue(
        TextEditingValue(text: widget.value.southwest.lat.toString()));
    _ctrlSwLng = TextEditingController.fromValue(
        TextEditingValue(text: widget.value.southwest.lng.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InputDecorator(
        decoration: InputDecoration(
          enabled: widget.enabled,
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(children: [
          _buildField("NE/Lat", _ctrlNeLat),
          _buildField("NE/Lng", _ctrlNeLng),
          _buildField("SW/Lat", _ctrlSwLat),
          _buildField("SW/Lng", _ctrlSwLng),
        ]),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Flexible(
      child: TextFormField(
        enabled: widget.enabled,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
        ],
        onChanged: (value) => _onValueChanged(controller, value),
        decoration: InputDecoration(label: Text(label)),
        // validator: _boundsValidator,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
      ),
    );
  }

  void _onValueChanged(TextEditingController ctrlNELat, String value) {
    final neLat = double.parse(ctrlNELat.value.text);

    LatLngBounds bounds = LatLngBounds(
        southwest: const LatLng(lat: 0.0, lng: 0.0),
        northeast: LatLng(lat: neLat, lng: 0.0));

    widget.onChanged(bounds);
  }
}

/// Creates a web-selectable text widget.
///
/// If the platform is web, the widget created is [SelectableText].
/// Otherwise, it's a [Text].
class WebSelectableText extends StatelessWidget {
  /// The text to display.
  ///
  /// This will be null if a [textSpan] is provided instead.
  final String data;

  /// Creates a web-selectable text widget.
  ///
  /// If the platform is web, the widget created is [SelectableText].
  /// Otherwise, it's a [Text].
  const WebSelectableText(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return SelectableText(data);
    }
    return Text(data);
  }
}
