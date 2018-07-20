/**
 * Created by zbrown on 7/8/2018.
 */

public class CSVReader {
    // CONSTRUCTORS
    public CSVReader( String inCsvString )
    {
        this(inCsvString,false);
    }

    public CSVReader( String inCsvString, Boolean inHasHeaders )
    {
        this.csvString = inCsvString;
        this.csvStringLength = inCsvString.length();
        this.hasHeaders = inHasHeaders;

        parseToMap();
    }


    // PUBLIC PROPERTIES
    public Integer recordCount {
        get{
            Integer returnValue = csvArray.size();

            if(hasHeaders && (returnValue > 0)){ returnValue = returnValue - 1; }

            return returnValue;
        }
    }

    public List<String> columnList { get; private set; }

    public String find(String thisColumn,Integer thisRow){
        String returnValue;

        returnValue = csvMap.get(thisColumn)[thisRow];
        return returnValue;
    }

    public List<List<string>> csvArray { get; private set; }
    public Map<String,List<String>> csvMap { get; private set; }


    // BEGIN PRIVATE VARIABLES

    private boolean EOF {
        get
        {
            if( this.position < this.csvStringLength )
                return false;
            else
                    return true;
        }
    }

    private String tokenString {
        get {
            if(!EOF){
                return this.csvString.mid(this.position,1);
            } else {
                return null;
            }
        }
    }

    private String lookAheadString {
        get {
            if((this.position + 1)  < this.csvStringLength){
                return this.csvString.mid(this.position+1,1);
            } else {
                return null;
            }
        }
    }

    private integer columnWidth = 0;
    private boolean hasHeaders;
    private string csvString;
    private integer csvStringLength;
    private integer position = 0;

    // STATIC CONSTANTS
    private static string COMMA = ',';
    private static string NL = '\n';
    private static string QUOTE = '"';
    private static string DOUBLE_QUOTE = '""';





    /**
     * Reads up to a unquoted newline delimiter
     *
     * @return list of cell contents
     */
    private List<String> parseLine(){
        List<String> returnValue = new List<String>();

        do {

            returnValue.add(parseCell());
            // throw away comma
            if( this.tokenString == COMMA){ this.position++; }
        } while((this.tokenString != null) && (this.tokenString != NL ));

        this.position++;

        if(returnValue.size() > columnWidth){ columnWidth = returnValue.size(); }

        return returnValue;
    }


    /**
     * Reads up to an unquoted comma or newline
     *
     * @return string of cell contents
     */
    private String parseCell(){
        String returnValue = '';
        Boolean isQuoteMode = false;
        Set<String> terminatorSet = new Set<String>();
        terminatorSet.add(COMMA);
        terminatorSet.add(NL);
        terminatorSet.add(null);

        do {
           if(isQuoteMode){
                if((this.tokenString == QUOTE) && (this.lookAheadString == QUOTE)){
                    returnValue = returnValue + QUOTE;
                    this.position = this.position + 2; // Jump ahead two
                } else if(this.tokenString == QUOTE){
                    this.position = this.position + 1; // Jump ahead one
                    isQuoteMode = false;
                } else {
                    returnValue = returnValue + this.tokenString;
                    this.position = this.position + 1; // Jump ahead one
                }

           } else {
               if(this.tokenString == QUOTE){
                   this.position = this.position + 1; // Jump ahead one
                   isQuoteMode = true;
               } else {
                   returnValue = returnValue + this.tokenString;
                   this.position = this.position + 1; // Jump ahead one
               }

           }

        } while(!terminatorSet.contains(this.tokenString) || (isQuoteMode == true));


        return returnValue;
    }

    /**
     * Convers an integer to an excel column
     *
     * @param columnNumber
     *
     * @return An excel header string
     */
    private String computeHeaderFromNumber(Integer columnNumber){
        String returnValue;
        String alphaList = 'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z';
        List<String> alphaArray = alphaList.split(',');

        returnValue = alphaArray[math.mod(columnNumber,26)];

        Integer pow = 1;
        while(columnNumber > Integer.valueOf(math.pow(26,pow))){
            returnValue = alphaArray[(columnNumber/Integer.valueOf(math.pow(26,pow)))] + returnValue;
            pow++;
        }

        return returnValue;
    }

    /**
     *  Parses the raw data into an double array of strings
     */
    private void parseToArray()
    {
        this.csvArray = new List<List<string>>();


        while(!EOF){
            this.csvArray.add(parseLine());
        }

    }

    /**
     * Converts the CSV array to a Map
     */
    private void parseToMap()
    {
        this.csvMap = new Map<String,List<String>>();

        parseToArray();
        this.columnList = new List<String>();
        Integer startIndex = 0;


        if(this.csvArray.size() > 0){
            if(this.hasHeaders){
                for(String mapKey : this.csvArray[0]){
                    this.csvMap.put(mapKey,new List<String>());
                    this.columnList.add(mapKey);
                }
                startIndex = 1;
            }
            else{
                for(Integer colnumber = 0; colnumber < this.csvArray[0].size(); colnumber++){
                    String mapKey = computeHeaderFromNumber(colnumber);
                    this.csvMap.put(mapKey,new List<String>());
                    this.columnList.add(mapKey);
                }
            }
            if(this.csvArray.size() > startIndex + 1){
                for(Integer row = startIndex; row < this.csvArray.size() ; row++ ){
                    List<String> thisRow = this.csvArray[row];

                    for(Integer index = 0; index < thisRow.size(); index++){
                        if(index < columnList.size()){
                            List<String> currentColumn = this.csvMap.get(this.columnList[index]);
                            currentColumn.add(thisRow[index]);
                            this.csvMap.put(this.columnList[index],currentColumn);
                        }
                    }

                }
            }
        }
    }
}