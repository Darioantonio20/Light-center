import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:light_center/Services/navigation_service.dart';
import 'package:light_center/Views/custom_widgets.dart';

class PDFScreen extends StatelessWidget {
  final String pdfName;
  const PDFScreen({super.key, required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppBar(
            title: Text(pdfName),
            actions: [
              IconButton(
                  onPressed: () => NavigationService.showSimpleErrorAlertDialog(
                    title: '¿Cómo funciona?',
                    content: 'Deslice su dedo de izquierda a derecha para mostrar la siguiente página, para regresar a la página anterior, deslice de derecha a izquierda.\n\nDe igual forma, puede utilizar los botones que se encuentran en la parte inferior de la pantalla.',
                  ),
                  icon: const Icon(Icons.help)),
            ]
        ),
        body: FutureBuilder<PDFDocument>(
          future: PDFDocument.fromAsset('assets/documents/$pdfName.pdf'),
          builder: (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
            if (snapshot.hasData) {
              return PDFViewer(
                showPicker: false,
                document: snapshot.data!,
                lazyLoad: false,
              );
            } else if (snapshot.hasError) {
              return errorScreen(context: context, errorMessage: 'El PDF no pudo ser cargado.');
            }
            return loadingScreen(context: context);
          },
        )
    );
  }
}