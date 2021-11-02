@isTest //(SeeAllData=True)
public with sharing class MatchTriggerTest {
    
    @testSetup static void setup() {
        // Create common test Teams
        List<Team__c> testTeam = new List<Team__c>();
        for(Integer i=0;i<2;i++) {
            testTeam.add(new Team__c(Name ='Team_'+i, Total_Active_Players__c =13));
        }
        insert testTeam;

        // Create common test Players
        List<Player__c> testPlayer = new List<Player__c>();
        Integer k=0;
        for (Integer j=0;j<testTeam.size();j++) {
            for(Integer i=0;i<=12;i++) {
                testPlayer.add(new Player__c(Name ='Player_'+k, Email__c ='Player_'+k+'@ukr.net', IsActive__c =True, Team__c=testTeam.get(j).id));
                k++;
            } 
        }             
        upsert testPlayer;

        // Create common test Match
        List<Match__c> testMatch = new List<Match__c>();
        Integer n=0, m=1;
        for(Integer i=0;i<3;i++) {
            testMatch.add(new Match__c(Name ='TestMatch_'+i, Start_DateTime__c =DateTime.now()+i, Home_Team__c =testTeam.get(n).Id, Visitors__c =testTeam.get(m).Id, Score__c ='00:00'));
            n = n<testTeam.size() ? n++ : 0;
            m = m<testTeam.size() ? m++ : 0;
        }
        upsert testMatch; 
        
        system.debug(System.LoggingLevel.DEBUG, testTeam);
        system.debug(System.LoggingLevel.DEBUG, testPlayer);
        system.debug(System.LoggingLevel.DEBUG, testMatch);            
    }
   @isTest public static void teamWinsUpdate(){
        //Set<Id> idsSet = new Set<Id>{'a0B090000029AQWEA2','a0B090000029AQgEAM'};
        List<Match__c> matchList = new List<Match__c>([SELECT id, Winner__c, Score__c, Home_Team__c, Visitors__c FROM Match__c LIMIT 2]);


        Test.startTest();
        Map<Id, Integer> tmpTeam= SoccerDAO.getTeamWins(matchList);
        List<Team__C> tmpTeamList = new List<Team__C>();
        for (Id tmp : tmpTeam.keySet()) {
            tmpTeamList.add(new Team__c(Id=tmp, Total_Wins__c=tmpTeam.get(tmp)));
        }
        update tmpTeamList;
        Test.stopTest();
   }
}