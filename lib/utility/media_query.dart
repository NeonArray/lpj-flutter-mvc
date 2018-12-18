import 'package:flutter/material.dart';


double getDeviceTargetWidth(BuildContext context) {
	final double deviceWidth = MediaQuery.of(context).size.width;
	return deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.85;
}

Map<String, double> getViewportDimensions(BuildContext context) {
	return {
		'height': MediaQuery.of(context).size.height,
		'width': MediaQuery.of(context).size.width,
	};
}

double getDeviceHeight(BuildContext context) {
	return MediaQuery.of(context).size.height;
}
