part of flutter_bottom_sheet_pickers.src;

class _SelectorListFooter {
  bool isLoading = true;
  _SelectorListFooter(this.isLoading);

  Widget show(BuildContext context, BottomPickerTheme themeData,
      BottomPickerLocalizations texts) {
    return Container(
      height: 80,
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(left: 5)),
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(themeData.checkedColor),
                    strokeWidth: 2,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                Text(
                  texts.loadingText,
                  style: TextStyle(color: themeData.checkedColor),
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
              ],
            )
          : Center(
              child: Text(
                texts.noMoreData,
                style: const TextStyle(color: Color(0xFF9FAABB)),
              ),
            ),
    );
  }
}
