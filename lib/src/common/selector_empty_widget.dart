part of flutter_bottom_sheet_pickers.src;

class _SelectorEmptyWidget extends StatelessWidget {
  final BottomPickerLocalizations texts;

  const _SelectorEmptyWidget({required this.texts});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -40),
        child: Text(
          texts.empty,
          style: const TextStyle(fontSize: 13, color: Color(0xFF455A64)),
        ),
      ),
    );
  }
}
