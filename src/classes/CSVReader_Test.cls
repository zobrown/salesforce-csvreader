/**
 * Created by zbrown on 7/20/2018.
 */

@isTest
public class CSVReader_Test {

    @testSetup
    public static void setUpTestData() {
        String str = 'Name,AccountNumber,Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';

    }


    static testMethod  void testCreateWithoutHeader(){
        String inputString = 'Id,Name,Description\nA0202033,Test 1,\"\"\" this is a quoted value\"\"\"\nA2023093,Test2,This is unquoted\nA3494494,Test 3,\"\"\" Single quote at the beginning\"\nA3334444,Test 4,\"This is unquoted\nThis has a new line\"\nA3334244,Test 5,\"This is unquoted,\nThis has a new line\"\nA3445566,Test 6,\"This, has a comma inside\"\n';


        CSVReader internalReader = new CSVReader(inputString);

    }

    static testMethod  void testCreateWithHeader(){

        String inputString = 'Name,AccountNumber,Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';
        CSVReader internalReader = new CSVReader(inputString,true);
        internalReader.find('Name',0);
    }

    static testMethod  void testTestController(){
        String inputString = 'Id,Name,Description\nA0202033,Test 1,\"\"\" this is a quoted value\"\"\"\nA2023093,Test2,This is unquoted\nA3494494,Test 3,\"\"\" Single quote at the beginning\"\nA3334444,Test 4,\"This is unquoted\nThis has a new line\"\nA3334244,Test 5,\"This is unquoted,\nThis has a new line\"\nA3445566,Test 6,\"This, has a comma inside\"\n';


        CSVTestController cont = new CSVTestController();
        CSVReader thisReader = cont.reader;

        Integer idx = cont.getCSVLength();
        List<Integer> thisRI = cont.recordIndex;


    }


}