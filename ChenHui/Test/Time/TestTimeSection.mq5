//+------------------------------------------------------------------+
//|                                              TestTimeChecker.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include "../../include/Time/TimeSection.mqh"

int OnInit()
{  
   Alert("TimeCurrent is ",TimeCurrent());
   Alert("TimeLocal is ",TimeLocal());
   TestIsTimeInSection();
   Alert("---------------Test all sections----------------");
   TestAllSections();
   Alert("---------------Test null sections----------------");
   TestNullSections();
   Alert("---------------Test time section checker----------------");
   TestTimeSectionChecker();
   return(0);
}

void TestTimeSectionChecker()
{

   Section section1To10={TODAY,1,TODAY,10};
   Section section20To3={TODAY,20,TOMORROW,3};

   TimeSectionChecker *checker;
   checker=new TimeSectionChecker;
   checker.InitOne(section1To10);
   checker.InitTwo(section20To3);
   datetime time201355=D'20:13:55';
   if (checker.IsTimeInSections(time201355))
      Alert("OK !",time201355, " is in ",section1To10.ToString()," or ",section20To3.ToString());
   else
      Alert(time201355, " is in ",section1To10.ToString()," or ",section20To3.ToString());
      
   datetime time111111=D'11:11:11';
   if (checker.IsTimeInSections(time111111))
      Alert(time111111, " is in ",section1To10.ToString()," or ",section20To3.ToString());
   else       
      Alert("OK !",time111111, " is not in ",section1To10.ToString()," or ",section20To3.ToString());
   
   if (checker!=NULL) delete checker;
}


void TestAllSections()
{
   Section section=AllSection;  
   datetime time011355=D'01:13:55'; 
   datetime time021355=D'02:13:55'; 
   datetime time031355=D'03:13:55';  
   datetime time041355=D'04:13:55'; 
   datetime time051355=D'05:13:55'; 
   datetime time111355=D'11:13:55';
   datetime time131355=D'13:13:55'; 
   datetime time151355=D'15:13:55'; 
   datetime time171355=D'17:13:55';
   datetime time201355=D'20:13:55'; 
   datetime time241355=D'24:13:55'; 
   
   TimeSection *timeSection;
   timeSection=new TimeSection;
   if (   IsTimeInSection(timeSection,time011355,section)
       && IsTimeInSection(timeSection,time021355,section)
       && IsTimeInSection(timeSection,time031355,section)
       && IsTimeInSection(timeSection,time041355,section)
       && IsTimeInSection(timeSection,time051355,section) 
       && IsTimeInSection(timeSection,time111355,section)
       && IsTimeInSection(timeSection,time131355,section)
       && IsTimeInSection(timeSection,time151355,section)
       && IsTimeInSection(timeSection,time171355,section) 
       && IsTimeInSection(timeSection,time201355,section)
       && IsTimeInSection(timeSection,time241355,section)    
       ) 
      Alert("OK ! all time  is in AllSection ");
   else Alert("No Ok ! all time is not in AllSection");
   if (timeSection!=NULL ) delete timeSection;
      
   
}

void TestNullSections()
{
   Section section=NullSection;  
   datetime time011355=D'01:13:55'; 
   datetime time021355=D'02:13:55'; 
   datetime time031355=D'03:13:55';  
   datetime time041355=D'04:13:55'; 
   datetime time051355=D'05:13:55'; 
   datetime time111355=D'11:13:55';
   datetime time131355=D'13:13:55'; 
   datetime time151355=D'15:13:55'; 
   datetime time171355=D'17:13:55';
   datetime time201355=D'20:13:55'; 
   datetime time241355=D'24:13:55'; 
   
   TimeSection *timeSection;
   timeSection=new TimeSection;
   if (   !IsTimeInSection(timeSection,time011355,section)
       && !IsTimeInSection(timeSection,time021355,section)
       && !IsTimeInSection(timeSection,time031355,section)
       && !IsTimeInSection(timeSection,time041355,section)
       && !IsTimeInSection(timeSection,time051355,section) 
       && !IsTimeInSection(timeSection,time111355,section)
       && !IsTimeInSection(timeSection,time131355,section)
       && !IsTimeInSection(timeSection,time151355,section)
       && !IsTimeInSection(timeSection,time171355,section) 
       && !IsTimeInSection(timeSection,time201355,section)
       && !IsTimeInSection(timeSection,time241355,section)    
       ) 
      Alert("OK ! all time  is not in null Section ");
   else Alert("No Ok ! some time is in null Section");
   if (timeSection!=NULL ) delete timeSection;
      
   
}

bool IsTimeInSection(TimeSection &timeSection,datetime time,Section &section)
{
   return (timeSection.Init(section) && timeSection.IsInclude(time));
}

void TestIsTimeInSection()
{
   TimeSection *timeSection;
   timeSection=new TimeSection;
   timeSection.Init(TODAY,16,TODAY,23);
   Alert("Test have 4 Ok! ");
   if (timeSection.IsInclude(TimeLocal()))  Alert(TimeLocal()," is in section today 16:00--23:00");
   else Alert(TimeLocal()," is not in section today 16:00--23:00");

   timeSection.Init(TODAY,16,TOMORROW,3);
   if (timeSection.IsInclude(TimeLocal()))    Alert(TimeLocal(), " is in section today 16:00--tomorrow 3:00");
   else Alert(TimeLocal()," is not in section today 16:00-- tomorrow 3:00 ");   
   
   timeSection.Init(TODAY,21,TOMORROW,3);
   datetime time201355=D'20:13:55';
   if (timeSection.IsInclude(time201355))       Alert(time201355," is in section today 21:00--tomorrow 3:00");
   else Alert("Ok ! ",time201355," is not in section today 21:00 -- tomorrow 3:00 ");  
   
   timeSection.Init(TODAY,22,TOMORROW,3);
   datetime time19800719=D'1980.07.19 1:30:27';
   if (timeSection.IsInclude(time19800719))       Alert("OK ! ",time19800719," is in section today 22:00 -- tomorrow 3:00");
   else Alert(time19800719," is not in section today 22:00 -- tomorrow 3:00 ");  
   
   timeSection.Init(TOMORROW,0,TODAY,0);
   datetime time19800819=D'1980.08.19 24:30:27';
   if (timeSection.IsInclude(time19800719))       Alert(time19800719," is in null section ");
   else Alert("OK ! ",time19800819," is not in null section  ");  
   
   timeSection.Init();
   datetime time2001=D'2011.22.21 04:23:44';
   if (timeSection.IsInclude(time2001)) Alert("OK ! ",time2001," is in all day section");
   else Alert(time2001," is not in all day section");
   
   timeSection.Init(TODAY,19,TOMORROW,3);
   Alert("Start time in server = ",timeSection.StartTimeOfOrder());
   Alert("End time in server = ",timeSection.EndTimeOfOrder());

   timeSection.Init(TODAY,3,TOMORROW,9);
   Alert("Start time in server = ",timeSection.StartTimeOfOrder());
   Alert("End time in server = ",timeSection.EndTimeOfOrder());
   

   delete timeSection; 
}

//------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   
}
//+------------------------------------------------------------------+
