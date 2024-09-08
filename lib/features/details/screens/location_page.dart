import 'package:alive_service_app/features/details/controller/user_details_controller.dart';
import 'package:alive_service_app/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends ConsumerStatefulWidget {
  final String currentUser;
  final Map<String, dynamic> worker;
  final String postalCode;
  final GlobalKey<FormState> formKey;
  final ValueChanged<List<double>> sendPostion;
  const LocationPage(
      {super.key,
      required this.formKey,
      required this.sendPostion,
      required this.postalCode,
      required this.currentUser,
      required this.worker});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationPageState();
}

class _LocationPageState extends ConsumerState<LocationPage> {
  final TextEditingController pincodeController = TextEditingController();

  String? currentPincode;
  Position? currPosition;
  List<Locations> locations = [];
  String? valueChoose;
  bool isLoading = false;

  void getLocation(String pincode) async {
    locations =
        await ref.read(userDetailsControllerProvider).getlocation(pincode);
    // print(locations.elementAt(0).state);
  }

  @override
  void initState() {
    pincodeController.text = "";
    if (widget.currentUser == 'true') {
      setValue();
    }
    super.initState();
  }

  @override
  void dispose() {
    pincodeController.dispose();
    super.dispose();
  }

  void setValue() async {
    List<Placemark> placemark = await ref
        .read(userDetailsControllerProvider)
        .getAddressFromLatLong(
            widget.worker['latitude'].toString(), widget.worker['logitude'].toString());
    currentPincode = placemark[0].postalCode;
    if (currentPincode == "" && placemark[0].locality != "") {
      currentPincode = placemark[0].locality;
    } else {
      currentPincode = placemark[0].administrativeArea;
    }
    pincodeController.text = currentPincode!;
    List<double> position = [
      widget.worker['latitude'],
      widget.worker['logitude']
    ];
    widget.sendPostion(position);
    setState(() {});
  }

  void currentLocation() async {
    currPosition =
        await ref.read(userDetailsControllerProvider).getCurrentLocation();
    List<Placemark> placemark = await ref
        .read(userDetailsControllerProvider)
        .getAddressFromLatLong(currPosition!.latitude.toString(),
            currPosition!.longitude.toString());
    currentPincode = placemark[0].postalCode;
    if (currentPincode == "" && placemark[0].locality != "") {
      currentPincode = placemark[0].locality;
    } else {
      currentPincode = placemark[0].administrativeArea;
    }
    pincodeController.text = currentPincode!;
    List<double> position = [currPosition!.latitude, currPosition!.longitude];
    widget.sendPostion(position);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: isLoading == true
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      currentLocation();
                    },
                    icon: pincodeController.text != ""
                        //  && pincodeController.text == currentPincode
                        ? const Icon(Icons.done)
                        : const Icon(Icons.location_on),
                    label: pincodeController.text != ""
                        //  && pincodeController.text == currentPincode
                        ? const Text('Location submitted')
                        : const Text('Use current location '))),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: pincodeController,
          readOnly: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Location',
            prefixIcon: Icon(Icons.home),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter valid pin";
            } else {
              return null;
            }
          },
          onChanged: (value) {
            value = pincodeController.text;
            getLocation(value);
            setState(() {});
            // print(value);
          },
          maxLength: 15,
        ),
        pincodeController.text != "" && pincodeController.text != currentPincode
            ? DropdownButtonFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.miscellaneous_services_outlined),
                    labelText: 'Select your location'),
                hint: const Text('   Select Location   '),
                iconSize: 36,
                value: valueChoose,
                onChanged: (newValue) {
                  setState(() {
                    valueChoose = newValue.toString();
                  });
                },
                items: locations.map((value) {
                  return DropdownMenuItem(
                    value: value.name,
                    child: Text('   ${value.name}  '),
                  );
                }).toList(),
              )
            : const SizedBox(),
      ],
    );
  }
}
