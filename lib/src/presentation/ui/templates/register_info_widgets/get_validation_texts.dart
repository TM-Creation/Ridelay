import 'package:flutter/material.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/validator_widgets/error_text.dart';

Widget _getRegistrationValidations(String value) {
  if (value == "image") {
    return errorValidator('Picture can not be empty', TextAlign.center);
  } else if (value == "image2") {
    return errorValidator(
        'Picture can not be empty', TextAlign.left);
  }else if (value == "image1") {
    return errorValidator(
        'Picture can not be empty', TextAlign.left);
  }else if (value == "nameerror") {
    return errorValidator(
        'Enter a valid Name', TextAlign.left);
  }else if (value == "phoneerror") {
    return errorValidator(
        'Enter a valid phone number with country extension', TextAlign.left);
  }
  else if (value == "phoneNumber") {
    return errorValidator(
        'Enter a valid phone number with country extension', TextAlign.left);
  } else if (value == "firstName") {
    return errorValidator('Please enter a valid first name', TextAlign.left);
  } else if (value == "passd") {
    return errorValidator('Please enter minimum 8 digit Password', TextAlign.left);
  } else if (value == "conpassd") {
    return errorValidator('Please enter minimum 8 digit Password', TextAlign.left);
  }else if (value == "lastName") {
    return errorValidator('Please enter a valid last name', TextAlign.left);
  } else if (value == "email") {
    return errorValidator('Please enter a valid email address', TextAlign.left);
  }  else if (value == "vehicleType") {
    return errorValidator('Please enter a valid vehicle type', TextAlign.left);
  } else if (value == "vehicleModelName") {
    return errorValidator('Please enter a valid vehicle model', TextAlign.left);
  } else if (value == "year") {
    return errorValidator('Please enter a valid Year', TextAlign.left);
  }  else if (value == "plateNumber") {
    return errorValidator('Please enter a valid plate number', TextAlign.left);
  }else if (value == "idNumber") {
    return errorValidator(
        'Please enter a valid identifiation number', TextAlign.left);
  }else if (value == "color") {
    return errorValidator(
        'Please enter Your Vehicle Color', TextAlign.left);
  } else if (value == "licenseNumber") {
    return errorValidator(
        'Please enter a valid license number', TextAlign.left);
  } else {
    return Container();
  }
}

Widget displayRegistrationValidation(String value) {
  return Padding(
    padding: const EdgeInsets.only(top: 5),
    child: _getRegistrationValidations(value),
  );
}
