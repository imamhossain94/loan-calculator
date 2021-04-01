
class RowData {
  final String payment, interest, principal, balance;
  RowData(this.payment, this.interest, this.principal, this.balance);

  String getIndex(int index) {
    switch (index) {
      case 0:
        return payment;
      case 1:
        return interest;
      case 2:
        return principal;
      case 3:
        return balance;
    }
    return '';
  }
}