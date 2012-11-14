//+------------------------------------------------------------------+
//|                                                         Rain.mq5 |
//|                                    Copyright 2010, Berron Parker |
//|                                               berron11@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, Berron Parker"
#property link      "berron11@gmail.com"
#property version   "1.00"

/* Uses three main indicators to determine when to enter and exit trades: 
Moving Average, ADX, the gradiant of a regression line.
It employs a break even and a trailing stop. Its been optimised for GBP/USD 30 min
1 year history (20110101-20110901).
*/

//---------------------------------------------------------------------
//	Included libraries:
//---------------------------------------------------------------------
#include <Trade\Trade.mqh> //original file
#include <Indicators_Logic.mqh>

//add class
// add trailing stop using envelopes


//EURUSD 30min chart

// Have Variables out here so they can be optimised in strategy tester.
input int      Stop_Loss = 130;             // Stop Loss 80, 15 ,110, 50
input int      Take_Profit = 220;           // Take Profit 110, 75, 100

input bool     Use_TrailingStop = true; // Use a trailing stop
input int      Trailing_Stop=35;  // Trailing Stop 100

input bool     Use_BreakEven = true; //use a break even point //false
input int      Move_ToBreakEvenAt_Pips = 10; //Moved to break even point at xx pips
input int      Lock_InPipsAtBreak_Even = 1;  //secure xx pips when break even point is reached
input int      DeviationA = 10;   // Maximum Deviation

input bool     UseCloseStrategy = false;     //use programmed close logic? false means just rely on SL and TP
input bool     UseReverseOrdering = false;   //Use buy signals to place sell orders...
input bool     SwitchOrderDirection = true;  //close all buy orders if a sell signal is received. and vice versa
input bool     UseCompoundOrders = true;    //Add to winning trades or not
input int      Minimum_Compound_Distance = 200; //if adding to winning positions the number of points between the new order and the already existing order

input double   Lot=2.0;           // Lots to Trade
input int      Margin_Chk=0;      // Check Margin before placing trade(0=No, 1=Yes)
input double   Trd_percent=5.0;   // Percentage of Free Margin To use for Trading

input bool     UseRestrictedTradingTime = false;   // Check whether to only open trades in a certain period
input int      GMTOffSet = -0;                   //used only during the championship to take in to account US server time.
input int      StartTradingHour = 13;           //12 or 13 or 14   // When trade server is later than this hour trading is allowed
input int      StopTradingHour = 17;              // When trade server is earlier than this hour trading is allowed

input int      MinimumMoneyProfitClosure = 100;   //used in close strategy
input int      Minimum_PipsProfitClosure = 20;    //used in close strategy

input int      VariableA = 1;                //

input int      ADX_Period=14;    // ADX Period
input double   Adx_Min=32.0;     // Minimum ADX Value

input ushort         Reg_dp_limiter  = 95;    //Regression indicator Reg_dp_limiter Number of data points
input uint           Reg_endpos      = 0;     //Regression indicator Reg_endpos Last value position
input double         Reg_multStdDev  = 1.96;  //Regression indicator Reg_multstdDevBands separation
//input inputs_switch  Reg_comments    = On;     // Comments switch
//input inputs_switch  Reg_record      = Off;    // Record info into a file text

input ENUM_TIMEFRAMES   MATimeframe=PERIOD_CURRENT;  // Moving Average Timeframe
input int               MA_Period=30;           // Moving Average Period

input int      EA_Magic=12349;      // EA Magic Number



//--- Other necessary parameters

int      StopLoss;      // Stop Loss
int      TrailingStop;  // Trailing Stop
int      TakeProfit;    // Take Profit
int      Deviation;
int      Move_ToBreakEvenAtPips;
int      Lock_InPipsAtBreakEven;
double   Minimum_CompoundDistance;
int      MinimumPipsProfitClosure;

double aprice;   // current Ask price
double astl;     // Stop Loss
double atkp;     // Take profit
int    adev;     // Maximum deviation

double bprice;   // current Ask price
double bstl;     // Stop Loss
double btkp;     // Take profit
int    bdev;     // Maximum deviation

// Create an object of our class
Indicators_Logic Indicators_Logic_Object; 
//use Indicators_Logic_Object to refer to the Indicators_Logic class


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  
//--- Do we have enough bars to work with
   int Mybars = Bars(_Symbol,_Period);
   if(Mybars<60)  // if total bars is less than 60 bars
     {
      Alert("We have less than 60 bars, But EA will carry on and not exit!!");
      //return(0);
     }  
     
   if(_Digits==5) //Add a 0 for 5 point market data
     {
      StopLoss = Stop_Loss*10;
      TrailingStop = Trailing_Stop*10;
      TakeProfit = Take_Profit*10;
      Deviation = DeviationA*10;
      Move_ToBreakEvenAtPips = Move_ToBreakEvenAt_Pips*10;
      Lock_InPipsAtBreakEven = Lock_InPipsAtBreak_Even*10;
      Minimum_CompoundDistance = Minimum_Compound_Distance*10;
      MinimumPipsProfitClosure = Minimum_PipsProfitClosure*10;
     }  
     
   if(_Digits==4)
     {
      StopLoss = Stop_Loss;
      TrailingStop = Trailing_Stop;
      TakeProfit = Take_Profit;
      Deviation = DeviationA;
      Move_ToBreakEvenAtPips = Move_ToBreakEvenAt_Pips;
      Lock_InPipsAtBreakEven = Lock_InPipsAtBreak_Even;
      Minimum_CompoundDistance = Minimum_Compound_Distance;
      MinimumPipsProfitClosure = Minimum_PipsProfitClosure;
     }    
   //--- Run Initialize function of the class
   Indicators_Logic_Object.doInit();
   Indicators_Logic_Object.SetupADX(ADX_Period,MA_Period,MATimeframe);
   Indicators_Logic_Object.SetupRegression(Reg_dp_limiter,Reg_endpos,Reg_multStdDev);
   //Indicators_Logic_Object.SetupRegression();
//--- Set all other necessary variables for our class object
   Indicators_Logic_Object.setPeriod(_Period);    // sets the chart period/timeframe
   Indicators_Logic_Object.setSymbol(_Symbol);    // sets the chart symbol/currency-pair
   Indicators_Logic_Object.setMagic(EA_Magic);    // sets the Magic Number
   Indicators_Logic_Object.setAdxMin(Adx_Min);    // sets the ADX miniumm value
   Indicators_Logic_Object.setVariableA(VariableA);    // sets the ADX miniumm value
   
   Indicators_Logic_Object.setUseTrailingStop(Use_TrailingStop);
   Indicators_Logic_Object.setUseBreakEven(Use_BreakEven);
   
   Indicators_Logic_Object.setTrailingStop(TrailingStop);
   Indicators_Logic_Object.setMoveToBreakEvenAtPips(Move_ToBreakEvenAtPips);
   Indicators_Logic_Object.setLockInPipsAtBreakEven(Lock_InPipsAtBreakEven);
   
   Indicators_Logic_Object.setMATimeframe(MATimeframe);    // set the MA Timeframe value
   Indicators_Logic_Object.setLOTS(Lot);                   // set the Lots value
   Indicators_Logic_Object.setDeviation(Deviation);        // set maximum deviation
   Indicators_Logic_Object.setCheckMargin(Margin_Chk);     // set the margin check variable
   Indicators_Logic_Object.setTradePercentage(Trd_percent);// set the percentage of Free Margin for trade
 
   //---
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  Indicators_Logic_Object.doUninit(); 
  ZeroMemory(TrailingStop);
  ZeroMemory(StopLoss);
  ZeroMemory(TakeProfit);
  //ZeroMemory(StartTradingHour);
  //ZeroMemory(StopTradingHour);
   //EventKillTimer();
  }

//+------------------------------------------------------------------+
//| What is the current time, can we trade                           |
//+------------------------------------------------------------------+  
bool CheckTime(int StartTrading_Hour, int StopTrading_Hour)
  {
   
   
   MqlDateTime dt;
   //datetime dt;
   TimeCurrent(dt);
   int CurrentHour = dt.hour;
   
   StartTrading_Hour = StartTrading_Hour + GMTOffSet;
   StopTrading_Hour = StopTrading_Hour + GMTOffSet;
  
   if(StartTrading_Hour<StopTrading_Hour) if(CurrentHour>=StartTrading_Hour && CurrentHour<StopTrading_Hour) return(true); // check if we are in the range
   if(StartTrading_Hour>StopTrading_Hour) if(CurrentHour>=StartTrading_Hour || CurrentHour<StopTrading_Hour) return(true);
   return(false);
  }
 
  
  
//+------------------------------------------------------------------+
//| What is the current time, can we trade                           |
//+------------------------------------------------------------------+  
void GetOrderValues()  
  {
   
   MqlTick latest_price;      // To be used for getting recent/latest price quotes
   
   //--- Get the latest price quote using the MQL5 MqlTick Structure
   if(!SymbolInfoTick(_Symbol,latest_price))
     {
      Alert("Error getting the latest price quote - error:",GetLastError(),"!!");
      return;
     }   
     
   //used to Open Buy Orders and Close Sell Orders
   aprice  = NormalizeDouble(latest_price.ask,_Digits);                     // current Ask price
   astl    = NormalizeDouble(latest_price.ask - StopLoss*_Point,_Digits);   // Stop Loss
   atkp    = NormalizeDouble(latest_price.ask + TakeProfit*_Point,_Digits); // Take profit
   adev    = DeviationA;                                                    // Maximum deviation

   //used to Opeb Sell Orders and Close Buy Orders  
   bprice  = NormalizeDouble(latest_price.bid,_Digits);                     // current bid price
   bstl    = NormalizeDouble(latest_price.bid + StopLoss*_Point,_Digits);   // Stop Loss was -
   btkp    = NormalizeDouble(latest_price.bid - TakeProfit*_Point,_Digits); // Take profit was +
   bdev    = DeviationA;                                                    // Maximum deviation
  
  }  
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   
   MqlRates mrate[];          // To be used to store the prices, volumes and spread of each bar
   ArraySetAsSeries(mrate,true); // the rates arrays

   if(CopyRates(_Symbol,_Period,0,8,mrate)<0)  //--- Get the details of the latest 8 bars
     {
      Alert("Error copying rates/history data - error:",GetLastError(),"!!");
      return;
     }

   Indicators_Logic_Object.setClosePrice(mrate[1].close);

//--- EA should only check for new trade if we have a new bar
// lets declare a static datetime variable
   static datetime Prev_time;
// lets declare a datetmie variable to hold the start time for the current bar (Bar 0)
   datetime Bar_time[1];
// copy the start time of the new bar to the variable
   Bar_time[0]=mrate[0].time;
// We don't have a new bar when both times are the same
   if(Prev_time==Bar_time[0])
     {
     return; //blank out so EA executes on every tick not just per bar
     }
//copy time to static value, save
   Prev_time=Bar_time[0];
   
//We have a NEW BAR so 1st check whether we have positions open and manage them (SL TP)
//then check whether to close them
//finally then check whether to open new orders and/or add to existing orders
   
    CompoundTrades(); 
         
//--- Do we have positions opened already?
   bool Buy_opened=false,Sell_opened=false; // variables to hold the result of the opened position

   if(PositionSelect(_Symbol)==true) // we have an opened position lets manage it.
     {
     //Print("+++++++ Open Order Exists 1=Buy, 0=Sell: ", PositionGetInteger(POSITION_TYPE));
     //Print("^^^^^^^ Lots currently in use : ", PositionGetDouble(POSITION_VOLUME));
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
        {
         Buy_opened=true;  //It is a Buy
         Indicators_Logic_Object.MoveStopLossAndBreakEven(); //Update SL
         if(UseCloseStrategy==true)
           {
            if(Indicators_Logic_Object.checkCloseBuy(MinimumMoneyProfitClosure, MinimumPipsProfitClosure)==true) //should position be closed?
              {
               Indicators_Logic_Object.CloseBuyPosition(); //if so close it
               //return;
              }
           }
        }
      else if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
        {
         Sell_opened=true; // It is a Sell
         Indicators_Logic_Object.MoveStopLossAndBreakEven();
         if(UseCloseStrategy==true)
           {
            if(Indicators_Logic_Object.checkCloseSell(MinimumMoneyProfitClosure, MinimumPipsProfitClosure)==true) //should position be closed?
              {
               Indicators_Logic_Object.CloseSellPosition(); // close sell position
               //return;
              }
           }
        }
     }

// Copy the bar close price for the previous bar prior to the current bar, that is Bar 1
   Indicators_Logic_Object.setClosePrice(mrate[1].close);  // bar 1 close price
//--- Check for Buy position

   if(Indicators_Logic_Object.checkOpenBuy()==true) //Checks buy logic which returns either true or false
     {
      // Do we already have an opened buy position
      //if(Buy_opened)
      if(Buy_opened==true && (Indicators_Logic_Object.CalculateVolume()+ PositionGetDouble(POSITION_VOLUME)) > MathMin(15,3*Indicators_Logic_Object.CalculateVolume()) ) //SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_LIMIT))
        {
         //Alert("Can not add anymore Buy Positions as you'll be over the maximum allowed trade size!!!");
         return;    // Don't open a new Buy Position
        }
         if((UseRestrictedTradingTime==true && CheckTime(StartTradingHour,StopTradingHour)==true) || UseRestrictedTradingTime==false) // place order addtime to trade here
           {//is it the correct time to trade?
           if(SwitchOrderDirection == true)//close all open sell orders
             {
              if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
                 {
                  Indicators_Logic_Object.CloseSellPosition();
                 } 
             }
           if(UseReverseOrdering==true)//place sell orders instead of buy orders
             {
              GetOrderValues();
              Indicators_Logic_Object.openSell(ORDER_TYPE_SELL,bprice,bstl,btkp,bdev); // place order
             }
           else
             {
              GetOrderValues();
              Indicators_Logic_Object.openBuy(ORDER_TYPE_BUY,aprice,astl,atkp,adev); // place order
             }
           }   
     }
     
     
//--- Check for any Sell position
   if(Indicators_Logic_Object.checkOpenSell()==true)
     {
      // Do we already have an opened Sell position
      //if(Sell_opened)
      if( Sell_opened==true  && (Indicators_Logic_Object.CalculateVolume() + PositionGetDouble(POSITION_VOLUME)) > MathMin(15,3*Indicators_Logic_Object.CalculateVolume()) )//SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_LIMIT))
        {
         //Alert("Can not add anymore Sell positions!!!");
         return;    // Don't open a new Sell Position
        }
        if((UseRestrictedTradingTime==true && CheckTime(StartTradingHour,StopTradingHour)==true) || UseRestrictedTradingTime==false) // place order addtime to trade here
           {
            if(SwitchOrderDirection == true)//close all open buy orders
             {
              if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
                 {
                  Indicators_Logic_Object.CloseBuyPosition();
                 } 
             }
           if(UseReverseOrdering==true)
             {
              GetOrderValues();
              Indicators_Logic_Object.openBuy(ORDER_TYPE_BUY,aprice,astl,atkp,adev); // place order 
             }
           else
             {
              GetOrderValues();
              Indicators_Logic_Object.openSell(ORDER_TYPE_SELL,bprice,bstl,btkp,bdev); // place order
             }
           }             
     }
   return;
  }
//+--------------------------------------------------------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Adding to existing orders                                        |
//+------------------------------------------------------------------+
void CompoundTrades()
 {
 
 //Compound add to winning orders (Sep 11) add sell
  if(UseCompoundOrders == true)
    {
     if(PositionSelect(_Symbol)==true) // we have an opened position lets add to it.
       {
        if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
          {
           if(PositionGetDouble(POSITION_PROFIT ) > 0)//order profitable
             {
              if( ( PositionGetDouble(POSITION_PRICE_CURRENT) - PositionGetDouble(POSITION_PRICE_OPEN) ) >= Minimum_CompoundDistance*_Point)//current price is greater than a set distance
                {//trade volume aloud
                if( PositionGetDouble(POSITION_VOLUME) < 15 ) //10
                  {
                   GetOrderValues(); //calculate SL TP 
                   Indicators_Logic_Object.openBuy(ORDER_TYPE_BUY,aprice,astl,atkp,adev); // place order
                  }
                }
             }
          }      
        if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
          {
           if(PositionGetDouble(POSITION_PROFIT) > 0)//order profitable
             {
              if( ( PositionGetDouble(POSITION_PRICE_OPEN) - PositionGetDouble(POSITION_PRICE_CURRENT)  ) >= Minimum_CompoundDistance*_Point)//current price is greater than a set distance
                {//trade volume aloud
                 if( PositionGetDouble(POSITION_VOLUME) < 15 )
                   {
                    GetOrderValues();
                    Indicators_Logic_Object.openSell(ORDER_TYPE_SELL,bprice,bstl,btkp,bdev); // place order
                   }
                }
             }
          }
       }  
    }
      
 }

