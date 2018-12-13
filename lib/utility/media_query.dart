import 'package:flutter/material.dart';


double getDeviceTargetWidth(BuildContext context) {
	final double deviceWidth = MediaQuery.of(context).size.width;
	return deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.85;
}
