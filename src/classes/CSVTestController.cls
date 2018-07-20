/**
 * Created by zb185019 on 7/18/2018.
 */

public with sharing class CSVTestController {
    public CSVTestController(){

    }

    public CSVReader reader {
        get{
            if(internalReader == null){
                StaticResource srObject = [select id,body from StaticResource Where Name = 'Excel_Example_File'];
                String contents = srObject.body.toString();
                internalReader = new CSVReader(contents,false);
                return internalReader;

            } else {
                return internalReader;
            }

        }
        private set;
    }

    public List<Integer> recordIndex {
        get{
            List<Integer> returnValue = new List<Integer>();
            for(Integer idx = 0; idx < internalReader.recordCount; idx++){
                returnValue.add(idx);
            }

            return returnValue;
        }
    }
    private CSVReader internalReader;

    public Integer getCSVLength() {

            return reader.recordCount;


    }



}