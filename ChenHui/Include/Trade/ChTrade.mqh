//+------------------------------------------------------------------+
//|                                                      ChTrade.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"


#include <Trade/Trade.mqh>

class ChTrade: public CTrade
{
   public:
      void ChTrade(){};
      void ~ChTrade(){};
      bool ClosePart(double volume,string symbol="",ulong deviation=-1);
}
;



bool ChTrade::ClosePart(double volume,string symbol,ulong deviation)
{
   bool   partial_close=false;
   int    retry_count  =20;
   uint   retcode      =TRADE_RETCODE_REJECT;
   if (volume==0) return (true);
//--- check stopped
   if(IsStopped(__FUNCTION__)) return(false);
//--- variables
   string action,result;
//--- clean
   ClearStructures();
   do
     {
      //--- checking
      if(PositionSelect(symbol))
        {
         if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
            //--- prepare request for close BUY position
            m_request.type =ORDER_TYPE_SELL;
            m_request.price=SymbolInfoDouble(symbol,SYMBOL_BID);
           }
         else
           {
            //--- prepare request for close SELL position
            m_request.type =ORDER_TYPE_BUY;
            m_request.price=SymbolInfoDouble(symbol,SYMBOL_ASK);
           }
        }
      else
        {
         //--- position not found
         m_result.retcode=retcode;
         return(false);
        }
      //--- setting request
      m_request.action      =TRADE_ACTION_DEAL;
      m_request.symbol      =symbol;
      m_request.deviation   =(deviation==ULONG_MAX) ? m_deviation : deviation;
      m_request.type_filling=m_type_filling;
      
      double  positionVolume=PositionGetDouble(POSITION_VOLUME);
      if (volume>=positionVolume)  m_request.volume=positionVolume;
      else  m_request.volume=volume;
      //--- check volume
      double max_volume=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
      if(m_request.volume>max_volume)
        {
         m_request.volume=max_volume;
         partial_close=true;
        }
      else
         partial_close=false;
      //--- order check
      if(!OrderCheck(m_request,m_check_result))
        {
         //--- copy return code
         m_result.retcode=m_check_result.retcode;
         if(m_log_level>LOG_LEVEL_NO)
            printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
         return(false);
        }
      //--- order send
      if(!OrderSend(m_request,m_result))
        {
         if(--retry_count!=0) continue;
         if(retcode==TRADE_RETCODE_DONE_PARTIAL)
            m_result.retcode=retcode;
         if(m_log_level>LOG_LEVEL_NO)
            printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
         return(false);
        }
      retcode=TRADE_RETCODE_DONE_PARTIAL;
      if(partial_close) Sleep(1000);
     }
   while(partial_close);
   if(m_log_level>LOG_LEVEL_ERRORS)
      printf(__FUNCTION__+": %s [%s]",FormatRequest(action,m_request),FormatRequestResult(result,m_request,m_result));
//--- ok
   return(true);

   
}
