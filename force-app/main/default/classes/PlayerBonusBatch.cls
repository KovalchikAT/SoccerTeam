global class PlayerBonusBatch implements Database.Batchable<sObject> {
    private map<Id, Integer> teamIdWinsMap;
    private Set<Id> idSet;
    private Integer base;
    global PlayerBonusBatch(map<Id, Integer> tmpMap, Integer tmpBase){
        teamIdWinsMap=tmpMap;
        idSet=teamIdWinsMap.keySet();
        base=tmpBase;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Bonus__c, Team__c FROM Player__c WHERE IsActive__c=True and  Team__c=:idSet';
        //SoccerDAO.getTeamWins(matchList);
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Player__c> playersList) {
        for(Player__c tmp : playersList) {        
            tmp.Bonus__c = base*teamIdWinsMap.get(tmp.Team__c);
        }
        try {
            update playersList;
        } catch(Exception e) {
            System.debug(e);
        }
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}
