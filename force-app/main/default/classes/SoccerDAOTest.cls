@isTest //(SeeAllData=True)
public with sharing class SoccerDAOTest {
    @testSetup static void setup() {
        // Create common test Teams
        List<Team__c> testTeam = new List<Team__c>();
        for(Integer i=0;i<2;i++) {
            testTeam.add(new Team__c(Name ='Team_'+i, Total_Active_Players__c =13));
        }
        testTeam.get(0).Total_Wins__c=2;
        insert testTeam;

        // Create common test Players
        List<Player__c> testPlayer = new List<Player__c>();
        Integer k=0;
        for (Integer j=0;j<testTeam.size();j++) {
            for(Integer i=0;i< 13;i++) {
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
        testMatch.get(0).Score__c= '00:01';
        testMatch.get(1).Score__c= '02:00';
        upsert testMatch; 
        
        system.debug(System.LoggingLevel.DEBUG, testTeam);
        system.debug(System.LoggingLevel.DEBUG, testPlayer);
        system.debug(System.LoggingLevel.DEBUG, testMatch);            
    }
    @isTest public static void getTeamsByIds(){
        Set<Id> idSet= new Set<Id>();
        for (Team__c tmp : [SELECT id FROM Team__c LIMIT 2]) {
            idSet.add(tmp.id);
        }
        Test.startTest();
        List<Team__c> tmp= SoccerDAO.getTeamsByIds(idSet);
        Test.stopTest();

        System.assertEquals([SELECT id, Name, Total_Wins__c, Total_Active_Players__c, Played_Home_Matches_Count__c FROM Team__c WHERE id =: idSet], tmp, 'getTeamsByIds valid');
    }
    @isTest public static void getActivePlayers(){
        Test.startTest();
        List<Player__c> tmp= SoccerDAO.getActivePlayers(10,4);
        Test.stopTest();

        System.assertEquals([SELECT id, Name, Email__c, IsActive__c, Team__c FROM Player__c WHERE IsActive__c=true ORDER BY Name LIMIT: 10 OFFSET: 4], tmp, 'getActivePlayers valid');
    }    
    @isTest public static void getMostWinnerTeam(){  
        Map<id, Integer> teamWinsMap = SoccerDAO.getTeamWins([SELECT id, score__c, Home_Team__c, Visitors__c FROM Match__c]);
        integer max =0;
        id tmpId;
        for (id tmp : teamWinsMap.keySet()) {
            if (teamWinsMap.get(tmp)>=max) {
               max= teamWinsMap.get(tmp);
               tmpId = tmp;
            }
        }
        Team__c retTeam = new Team__c(id=tmpId);

        Test.startTest();
        Team__c tmp= SoccerDAO.getMostWinnerTeam(); 
        Test.stopTest();

        System.assertEquals(retTeam, tmp, 'getMostWinnerTeam valid');    
    }
    @isTest public static void getWonMatchesCountByTeamId(){
        List<Team__c> teamList= new List<Team__c>([SELECT id, Total_Wins__c FROM Team__c]);
        Id tmpId = teamList.get(0).Id;
        Integer retTmp =(Integer)teamList.get(0).Total_Wins__c;

        Test.startTest();
        Integer tmp = SoccerDAO.getWonMatchesCountByTeamId(tmpId);
        Test.stopTest();

        System.assertEquals(retTmp,tmp,'getWonMatchesCountByTeamId valid');
    }
    @isTest public static void getTeamsWithPlayerNumber(){
        Set<Id> idSet= new Set<Id>{};
        for (Team__c tmp : new List<Team__c>([SELECT id FROM Team__c])){
            idSet.add(tmp.id);
        }
        Map<Id,Integer> teamActivePlayersCount = new Map<Id,Integer>();
        for (AggregateResult tmpAggrResalt :  [select count(id) countID, team__c from player__c where isActive__c=true and team__c=:idSet GROUP BY team__c]) {
            teamActivePlayersCount.put((Id)tmpAggrResalt.get('team__c'), (integer)tmpAggrResalt.get('countID'));        
        }
        
        Test.startTest();
        Map<Id, Integer> tmp= SoccerDAO.getTeamsWithPlayerNumber(idSet);
        Test.stopTest();

        System.assertEquals(teamActivePlayersCount,tmp,'getTeamsWithPlayerNumber valid');
    }
    @isTest public static void getTeamStatistics(){
        Set<Id> idSet= new Set<Id>();
        Integer playerCount=0 , average=0;
        for (Team__c tmp : [SELECT id, Total_Active_Players__c FROM Team__c ]) {
            idSet.add(tmp.id);
        }

        Map<Id, Integer> teamWithPlayer = SoccerDAO.getTeamsWithPlayerNumber(idSet);
        for (id tmp : teamWithPlayer.keySet()) {
            average=average+teamWithPlayer.get(tmp);   
            playerCount++;          
        }
        Integer retTmp =(Integer)average/playerCount;

        Test.startTest();
        Integer statTmp = SoccerDAO.getTeamStatistics(idSet);
        Test.stopTest();

        System.assertEquals(retTmp,statTmp,'getTeamStatistics valid');
    }
    @isTest public static void getTeamWithMostScores(){

        List<Team__c> teamList = new List<Team__c>([SELECT id FROM Team__c]);
        List<Match__c> matchList = new List<Match__c>([SELECT id, score__c, Home_Team__c, Visitors__c FROM Match__c]);
        Integer score=0, max=0;
        Team__c retTeam;
        for (Team__c tmpTeam : teamList) {
            score=0;
            for (Match__c tmpMatch: matchList){
                Integer a = Integer.valueOf(tmpMatch.score__c.substringBefore(':'));
                Integer b = Integer.valueOf(tmpMatch.score__c.substringAfter(':'));
                if((a>b && tmpMatch.Home_Team__c==tmpTeam.id)||(a<b && tmpMatch.Visitors__c==tmpTeam.id)){
                    score=score+2;
                }
                if(a==b && (tmpMatch.Home_Team__c==tmpTeam.id || tmpMatch.Visitors__c==tmpTeam.id)){
                    score=score+1;
                }
            }
            if (max<score) {
                max=score;
                retTeam=tmpTeam;
            }
        }

        Test.startTest();
        Team__c tmp= SoccerDAO.getTeamWithMostScores();
        Test.stopTest();
        
        System.assertEquals(retTeam,tmp,'getTeamWithMostScores valid');
    }
    @isTest public static void getTeamWins(){
        Map<Id, Integer> resTmp= new Map<Id, Integer>();
        Set<Id> matchIdSet= new Set<Id>();
        List<Match__c> matchList = new List<Match__c>([SELECT id, score__c, Home_Team__c, Visitors__c FROM Match__c LIMIT 2]);

        for (Match__c tmp: matchList){
            matchIdSet.add(tmp.id);
            if (!resTmp.containsKey(tmp.Home_Team__c))  {    resTmp.put(tmp.Home_Team__c,0);}
            if (!resTmp.containsKey(tmp.Visitors__c))   {    resTmp.put(tmp.Visitors__c,0);}

            Integer a = Integer.valueOf(tmp.score__c.substringBefore(':'));
            Integer b = Integer.valueOf(tmp.score__c.substringAfter(':'));

            if(a>b){
                if (resTmp.containsKey(tmp.Home_Team__c)){
                    resTmp.put(tmp.Home_Team__c,resTmp.get(tmp.Home_Team__c)+1);
                }
            }
            if(a<b){
                if (resTmp.containsKey(tmp.Visitors__c)){
                    resTmp.put(tmp.Visitors__c,resTmp.get(tmp.Visitors__c)+1);
                }
            }
        }
        
        Test.startTest();
        Map<Id, Integer> tmpMap= SoccerDAO.getTeamWins([SELECT id, score__c, Home_Team__c, Visitors__c FROM Match__c WHERE id=:matchIdSet]);
        Test.stopTest();

        System.assertEquals(resTmp,tmpMap,'getTeamWins valid');
    }
}