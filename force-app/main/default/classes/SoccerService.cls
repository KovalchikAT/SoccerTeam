public with sharing class SoccerService {
   
    class ScoreHelper{
        public ScoreHelper(id tmpId, Integer tmpHomeTeamScore, Integer tmpVisitorsTeamScore){
            matchId=tmpId;
            homeTeamScore=tmpHomeTeamScore;
            visitorsTeamScore=tmpVisitorsTeamScore;
        }
        Id matchId;
        Integer homeTeamScore;
        Integer visitorsTeamScore;
       }
   
    public static void createPlayer(String name, String email, Map<SObjectField, Object> extraValues){
        Player__c retPlayer= new Player__c();
        retPlayer.Name=name;
        retPlayer.Email__c=email;
        for (SObjectField tmp : extraValues.keySet()) {
            if(tmp==Schema.sObjectType.Player__c.fields.getMap().get('IsActive__c')){
                retPlayer.IsActive__c=(Boolean)extraValues.get(tmp);
            }
        }
        try {
            upsert retPlayer;
        } catch (DmlException e) {
            System.debug('A DML insert exception has occurred: ' + e.getMessage());
        }
    }

    public static void arangeMatch(DateTime dt, Id homeTeamId, Id visitorsTeamId){
        Match__c retMatch= new Match__c();
        retMatch.Start_DateTime__c=dt;
        retMatch.Home_Team__c=homeTeamId;
        retMatch.Visitors__c=visitorsTeamId;
        try {
            insert retMatch;
        } catch (DmlException e) {
            System.debug('A DML insert exception has occurred: ' + e.getMessage());
        }
    }
    public static void setScoreToMatches(List<ScoreHelper> scores){
        List<Match__c> retMatch= new List<Match__c>();
        for (ScoreHelper tmp : scores) {
            retMatch.add(new Match__c(id=tmp.matchId, Score__c=tmp.homeTeamScore+':'+tmp.visitorsTeamScore));
        }
        try {
            upsert retMatch;
        } catch (DmlException e) {
            System.debug('A DML upsert exception has occurred: ' + e.getMessage());
        }
    }
    public static void deactivatePlayers(List<Id> playersIds){
        List<Player__c> retPlayer = new List<Player__c>();
        for (id tmp : playersIds) {
            Player__c tmpPlayer= new Player__c(Id=tmp, isActive__c=False);
            retPlayer.add(tmpPlayer);
        }
        try {
            upsert retPlayer;
        } catch (DmlException e) {
            System.debug('A DML upsert exception has occurred: ' + e.getMessage());
        }
    }
    
}
