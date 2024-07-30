public class QBPaymentResponseJSON {

	public class Line {

		public Line(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Line consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Payment {
		public CustomerRef CustomerRef {get;set;} 
		public DepositToAccountRef DepositToAccountRef {get;set;} 
		public Integer TotalAmt {get;set;} 
		public Integer UnappliedAmt {get;set;} 
		public Boolean ProcessPayment {get;set;} 
		public String domain {get;set;} 
		public Boolean sparse {get;set;} 
		public String Id {get;set;} 
		public String SyncToken {get;set;} 
		public MetaData MetaData {get;set;} 
		public String TxnDate {get;set;} 
		public CustomerRef CurrencyRef {get;set;} 
		public List<Line> Line {get;set;} 

		public Payment(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CustomerRef') {
							CustomerRef = new CustomerRef(parser);
						} else if (text == 'DepositToAccountRef') {
							DepositToAccountRef = new DepositToAccountRef(parser);
						} else if (text == 'TotalAmt') {
							TotalAmt = parser.getIntegerValue();
						} else if (text == 'UnappliedAmt') {
							UnappliedAmt = parser.getIntegerValue();
						} else if (text == 'ProcessPayment') {
							ProcessPayment = parser.getBooleanValue();
						} else if (text == 'domain') {
							domain = parser.getText();
						} else if (text == 'sparse') {
							sparse = parser.getBooleanValue();
						} else if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'SyncToken') {
							SyncToken = parser.getText();
						} else if (text == 'MetaData') {
							MetaData = new MetaData(parser);
						} else if (text == 'TxnDate') {
							TxnDate = parser.getText();
						} else if (text == 'CurrencyRef') {
							CurrencyRef = new CustomerRef(parser);
						} else if (text == 'Line') {
							Line = arrayOfLine(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Payment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DepositToAccountRef {
		public String value {get;set;} 

		public DepositToAccountRef(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DepositToAccountRef consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class MetaData {
		public String CreateTime {get;set;} 
		public String LastUpdatedTime {get;set;} 

		public MetaData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CreateTime') {
							CreateTime = parser.getText();
						} else if (text == 'LastUpdatedTime') {
							LastUpdatedTime = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MetaData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Payment Payment {get;set;} 
	public String time_Z {get;set;} // in json: time

	public QBPaymentResponseJSON(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Payment') {
						Payment = new Payment(parser);
					} else if (text == 'time') {
						time_Z = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'QBPaymentResponseJSON consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class CustomerRef {
		public String value {get;set;} 
		public String name {get;set;} 

		public CustomerRef(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomerRef consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static QBPaymentResponseJSON parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new QBPaymentResponseJSON(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	








    private static List<Line> arrayOfLine(System.JSONParser p) {
        List<Line> res = new List<Line>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Line(p));
        }
        return res;
    }



}