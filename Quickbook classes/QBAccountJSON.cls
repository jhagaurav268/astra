public class QBAccountJSON {

    public QueryResponse QueryResponse;

	public class QueryResponse {
		public List<Account> Account;
		public Integer startPosition;
	}
    
    public class Account {
		public String FullyQualifiedName;
        public String domain;
        public String Name;
        public String Classification;
		public String AccountSubType;
		public Decimal CurrentBalanceWithSubAccounts;
		public Boolean sparse;
		public String AccountType;
		public Decimal CurrentBalance;
		public String Active;
		public String SyncToken;
		public String Id;
		public String SubAccount;
        public CurrencyRef CurrencyRef;
        public MetaData MetaData;
	}

    
	public class CurrencyRef {
		public string name;
        public string value;
    }


	public class MetaData {
		public String CreateTime;
		public String LastUpdatedTime;
	}


	public static QBAccountJSON parse(String json) {
		return (QBAccountJSON) System.JSON.deserialize(json, QBAccountJSON.class);
	}
}