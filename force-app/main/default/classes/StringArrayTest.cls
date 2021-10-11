public with sharing class StringArrayTest {
    private List<String> testList;
    public StringArrayTest() {
       testList = new List<String>();
    }
    public StringArrayTest(Integer size) {
        Integer i=0;
        TestList = new List<String>();
        do{
           TestList.add('Test '+str(i));
           i++;
        } while (i<size);
    }
    public static List<String> generateStringArray(integer size){
        StringArrayTest(size);
    return  TestList;
    }

}