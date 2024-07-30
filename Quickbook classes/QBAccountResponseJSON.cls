public class QBAccountResponseJSON {
	public Account Account;
	public String times;

    public class Account {
        public String FullyQualifiedName;
        public String domain;
        public String Name;
        public String Classification;
        public String AccountSubType;
        public CurrencyRef CurrencyRef;
        public Decimal CurrentBalanceWithSubAccounts;
        public Boolean sparse;
        public MetaData MetaData;
        public String AccountType;
        public Decimal CurrentBalance;
        public Boolean Active;
        public String SyncToken;
        public String Id;
        public Boolean SubAccount;
    }

    public class CurrencyRef {
        public String name;
        public String value;
    }

    public class MetaData {
        public String CreateTime;
        public String LastUpdatedTime;
    }

    public static QBAccountResponseJSON parse(String json) {
        return (QBAccountResponseJSON) System.JSON.deserialize(json, QBAccountResponseJSON.class);
    }
}