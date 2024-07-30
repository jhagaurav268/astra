public class QBPaymentJSON {

	public class Line {
		public Decimal Amount;
		public List<LinkedTxn> LinkedTxn;
	}

	public Double TotalAmt;
	public List<Line> Line;
	public CustomerRef CustomerRef;
    public PaymentMethodRef PaymentMethodRef;

	public class CustomerRef {
		public String value;
	}
    
    public class PaymentMethodRef{
        public String value;
    }

	public class LinkedTxn {
		public String TxnId;
		public String TxnType;
	}

	
	public static QBPaymentJSON parse(String json) {
		return (QBPaymentJSON) System.JSON.deserialize(json, QBPaymentJSON.class);
	}
}