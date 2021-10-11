public with sharing class AccountHandler {
    public static Account insertNewAccount(String tmpName)
    {
        try {
            Account acct = new Account(Name=tmpName);
            insert acct;
    
        } catch (DmlException e) {
            System.debug('A DML exception has occurred: ' + e.getMessage());
            return null;
        }
        return acct;
    }
}
