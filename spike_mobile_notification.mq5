//+------------------------------------------------------------------+
//|                                    spike_mobile_notification.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"



//+------------------------------------------------------------------+
//| Variables                                                        |
//+------------------------------------------------------------------+

string what_index="Dont_Know_Yet";
double highest_value_difference = 0;



bool   is_spike = false;
string candle_or_spike="Nothing";


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
       string symbol_name = _Symbol;
            
            if(StringFind(symbol_name,"Boom") != -1){
               what_index="Boom";
              }else  if(StringFind(symbol_name,"Crash") != -1){
            
                what_index="Crash";
                   
            };
         
         
            int bars=2000;    
            
            double Close[];
            double  Open[];
            double difference[];
            
            ArrayResize(Close,bars);
            ArrayResize(Open,bars);
            ArrayResize(difference,bars);
 
            
            CopyClose(_Symbol, _Period, 0,bars,Close);
            CopyOpen(_Symbol, _Period, 0,bars,Open);
         
            
             for(int i = 0; i<bars-1; i++){
                  
                 double open_close_difference = MathAbs(Close[i] - Open[i]);   
                 difference[i] = open_close_difference;
                  Print(open_close_difference);
               
            };
            
      
           double less_than_one_array[];
           ArrayResize(less_than_one_array,bars+1);
               
           for(int i = 0; i<bars-1; i++){
                      if( difference[i] < 1){
                             less_than_one_array[i] = difference[i];
                        }else{
                        
                          less_than_one_array[i] = 0;
                        };
                
           };
            
           ArraySort(less_than_one_array);                       
         
           highest_value_difference = less_than_one_array[bars];
   
   



//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

            double current_price = SymbolInfoDouble(_Symbol,SYMBOL_BID);
             double close_for_last_candle = iClose(_Symbol,PERIOD_CURRENT,1);
              
             double diff = MathAbs(close_for_last_candle - current_price  );
             if(diff < highest_value_difference){
                 is_spike = false;
                 candle_or_spike= "Candle";
               
              
                  
             }else if(diff > highest_value_difference){
               
               candle_or_spike= "Spike";       
               if(!is_spike){
                    string message = "Spike alert on " + Symbol() ;
                    SendNotification(message);
                    
                    is_spike = true;
               
                  }
             }
             
                     
            Comment("Currently in a : ",candle_or_spike);



  }
//+------------------------------------------------------------------+
