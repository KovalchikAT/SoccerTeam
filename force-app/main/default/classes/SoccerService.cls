public with sharing class SoccerService {
   
    public static void createPlayer(String name, String email, Map<SObjectField, Object> extraValues){
        Player__c retPlayer= new Player__c();
        retPlayer.Name=name;
        retPlayer.Email__c=email;
        retPlayer.Team__c=extraValues.get('Team__c');
        retPlayer.IsActive__c=extraValues.get('IsActive__c');
        try {
            insert retPlayer;
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
        List<Match__c> retMatch= new List<Match__c>([SELECT id, Name, Start_DateTime__c, Home_Team__c, 
                                                            Visitors__c, Days_Left__c, Previous_Match_Between_Teams_Datetime__c, 
                                                            Score__c, Winner__c FROM Match__c WHERE id =: scores.matchId]);
        for (ScoreHelper tmp : scores) {
            retMatch.get(retMatch.indexOf(tmp.matchId)).Score__c=tmp.homeTeamScore+':'+tmp.visitorsTeamScore;
        }
        try {
            upsert retMatch;
        } catch (DmlException e) {
            System.debug('A DML upsert exception has occurred: ' + e.getMessage());
        }
    }
    public static void deactivatePlayers(List<Id> playersIds){
        List<Player__c> retPlayer = new List<Player__c>([SELECT id, Name, Email__c, Team__c, IsActive__c FROM Player__c WHERE id =: playersIds]);
        for (Player__c tmp : retPlayer) {
            tmp.IsActive__c=False;
        }
        try {
            upsert retPlayer;
        } catch (DmlException e) {
            System.debug('A DML upsert exception has occurred: ' + e.getMessage());
        }
    }
    class ScoreHelper{
        ScoreHelper(id tmpId, Integer tmpHomeTeamScore, Integer tmpVisitorsTeamScore){
            matchId=tmpId;
            homeTeamScore=tmpHomeTeamScore;
            visitorsTeamScore=tmpVisitorsTeamScore;
        }
        Id matchId;
        Integer homeTeamScore;
        Integer visitorsTeamScore;
       }
}
