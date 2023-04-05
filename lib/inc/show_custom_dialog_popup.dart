import 'package:flutter/material.dart';

// Convenient method for easily display a top modal
// Here we can customize more
Future<dynamic> showCustomDialogPopup<T>(BuildContext context, Widget child) {
  return showGeneralDialog<dynamic>(
    context: context,
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 250),
    barrierLabel: MaterialLocalizations.of(context).dialogLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, _, __) => child,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)
            .drive(
                Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero)),
        child: Column(
          children: [
            Expanded(
              child: Material(
                color: Colors.black.withOpacity(0.5),
                child: child,
              ),
            )
          ],
        ),
      );
    },
  );
}
