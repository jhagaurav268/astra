public class QBProductJSON {

	public class Item {
		public String FullyQualifiedName {get;set;} 
		public String domain {get;set;} 
		public String Name {get;set;} 
		public Boolean TrackQtyOnHand {get;set;} 
		public String Type {get;set;} 
		public Decimal PurchaseCost {get;set;} 
        public Integer QtyOnHand {get;set;} 
        public String InvStartDate {get;set;} 
		public IncomeAccountRef IncomeAccountRef {get;set;} 
        public ExpenseAccountRef ExpenseAccountRef {get;set;} 
        public AssetAccountRef AssetAccountRef {get;set;} 
		public Boolean Taxable {get;set;} 
		public Boolean sparse {get;set;} 
		public Boolean Active {get;set;} 
		public String SyncToken {get;set;} 
		public Integer UnitPrice {get;set;} 
		public String Id {get;set;} 
		public String Description {get;set;} 
        public String Sku{get;set;}
	}
		
	public class QueryResponse {
		public List<Item> Item {get;set;} 
    }
	
	public QueryResponse QueryResponse {get;set;} 
	public String time_Z {get;set;} // in json: time

	
	public class IncomeAccountRef {
		public String name {get;set;} 
		public String value {get;set;} 
    }
    
    public class ExpenseAccountRef {
		public String name {get;set;} 
		public String value {get;set;} 
    }
    
    public class AssetAccountRef {
		public String name {get;set;} 
		public String value {get;set;} 
    }
	
	public static QBProductJSON parse(String json) {
        return (QBProductJSON) System.JSON.deserialize(json, QBProductJSON.class);
	}
	
}