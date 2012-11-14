//+------------------------------------------------------------------+
//|                                                  TimeSection.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

enum DAY{
   TODAY=0,
   TOMORROW=1
};

struct Section
{
   int startDay;
   int startHour;
   
   int endDay;
   int endHour;
   string ToString()
   {
      string startDayString;
      string endDayString;
      if (startDay==TODAY)  startDayString="  TODAY  ";
      if (startDay==TOMORROW)  startDayString ="  TOMORROW  ";
      if (endDay==TODAY)  endDayString="  TODAY  ";
      if (endDay==TOMORROW)  endDayString ="  TOMORROW  ";
      return startDayString+IntegerToString(startHour)+"---"+endDayString+IntegerToString(endHour);
   }
};

Section NullSection={TOMORROW,0,TODAY,0};
Section AllSection={TODAY,0,TODAY,0};
Section AsianSection={TODAY,0,TODAY,7};
Section EuropeSection={TODAY,8,TODAY,14};
Section AmericanSection={TODAY,15,TODAY,23};
Section DayCleanSection={TODAY,23,TODAY,24};



class  TimeSection
{
   private:

      int today;
      int tomorrow;
      
      int startDay;
      int startHour;
      int endDay;
      int endHour;
      
      bool IsIncludeToday(datetime time);
      bool IsIncludeTomorrow(datetime time);
      bool IsIncludeAll();
      int HourOf(datetime time);      

      datetime ServerTimeOf(int hour);
      int HourDifferenceLocalToServer();
      
   public:
   
      void TimeSection();
      void ~TimeSection();
      bool Init(int startDay=0,int startHour=0,int endDay=0,int endHour=0);
      bool Init(Section &section);
      bool IsInclude(datetime time);
      datetime  StartTimeOfOrder();
      datetime  EndTimeOfOrder();
      
};
   
void TimeSection::TimeSection(void)
{
   today=0;
   tomorrow=1;
}

void TimeSection::~TimeSection(void){}
   
bool TimeSection::Init(int startDay,int startHour,int endDay,int endHour)
{
   this.startDay=startDay;
   this.startHour=startHour;
   this.endDay=endDay;
   this.endHour=endHour;
   return (true);
}

bool TimeSection::Init(Section &section)
{

   this.startDay=section.startDay;
   this.startHour=section.startHour;
   this.endDay=section.endDay;
   this.endHour=section.endHour;
   return (true);
}

bool TimeSection::IsInclude(datetime time)
{
   //printf("IsIncludeAll is %d ,IsIncludeToday=%d, IsIncludeTomorrow=%d",IsIncludeAll(),IsIncludeToday(time),IsIncludeTomorrow(time));
   return (    IsIncludeAll()
          ||   IsIncludeToday(time)
          ||   IsIncludeTomorrow(time));         
}   

bool TimeSection::IsIncludeAll()
{
   return (this.startDay==0 && this.startHour==0 && this.endDay==0 && this.endHour==0);
}

bool TimeSection::IsIncludeToday(datetime time)
{
   return (startDay==today && endDay==today && HourOf(time)>=startHour && HourOf(time)<endHour);
}


bool TimeSection::IsIncludeTomorrow(datetime time)
{
   return (startDay==today && endDay==tomorrow && !(HourOf(time)<startHour && HourOf(time)>=endHour ));
}

int TimeSection::HourOf(datetime time)
{
   MqlDateTime timeStruct;
   TimeToStruct(time,timeStruct);   
   return (timeStruct.hour);   
}

datetime TimeSection::StartTimeOfOrder(void)
{
   return ServerTimeOf(startHour);
}


datetime TimeSection::EndTimeOfOrder(void)
{
   return ServerTimeOf(endHour);
}

datetime TimeSection::ServerTimeOf(int hour)
{
   MqlDateTime timeStruct;
   timeStruct.year=1970;
   timeStruct.mon=1;
   timeStruct.day=1;
   timeStruct.hour=MathMod(hour-HourDifferenceLocalToServer()+24,24);
   timeStruct.min=0;
   timeStruct.sec=0;
   return  (StructToTime(timeStruct));   
}


int TimeSection::HourDifferenceLocalToServer()
{
   MqlDateTime currentTimeStruct;
   MqlDateTime localTimeStruct;
   TimeCurrent(currentTimeStruct);
   TimeLocal(localTimeStruct);
   return (localTimeStruct.hour-currentTimeStruct.hour);
   
}

class TimeSectionChecker
{
   private:
   
      TimeSection *timeSection;
      Section zero;
      Section one;
      Section two;
      Section three;
      Section four;
      Section five;
      Section six;
      Section seven;
      Section eight;
      Section nine;
      Section ten;
      bool IsIn(Section &section,datetime time);
      
   public:
      void TimeSectionChecker();
      void ~TimeSectionChecker(){if (timeSection!=NULL) delete timeSection;};
      void InitOne(Section &one){this.one=one;};
      void InitTwo(Section &two){this.two=two;};
      void InitThree(Section &three){this.three=three;};
      void InitFour(Section &four){this.four=four;};
      void InitFive(Section &five){this.five=five;};
      void InitSix(Section &six){this.six=six;};
      void InitSeven(Section &seven){this.seven=seven;};
      void InitEight(Section &eight){this.eight=eight;};
      void InitNine(Section &nine){this.nine=nine;};
      void InitTen(Section &ten){this.ten=ten;};
      bool IsTimeInSections(datetime time);
};

void TimeSectionChecker::TimeSectionChecker(void)
{
   this.timeSection=new TimeSection;
   this.one=NullSection;
   this.two=NullSection;
   this.three=NullSection;
   this.four=NullSection;
   this.five=NullSection;
   this.six=NullSection;
   this.seven=NullSection;
   this.eight=NullSection;
   this.nine=NullSection;
   this.ten=NullSection;
}


bool TimeSectionChecker::IsTimeInSections(datetime time)
{
   //Alert(one.ToString(),two.ToString(),three.ToString());
   return (   IsIn(one,time)
           || IsIn(two,time)   
           || IsIn(three,time)
           || IsIn(four,time)
           || IsIn(five,time)
           || IsIn(six,time)
           || IsIn(seven,time)
           || IsIn(eight,time)
           || IsIn(nine,time)
           || IsIn(ten,time)
           );
}

bool TimeSectionChecker::IsIn(Section &section,datetime time)
{
   return timeSection.Init(section) && timeSection.IsInclude(time);
}


class TimeCheckerYielder
{
   private:
      TimeSectionChecker  *timeChecker;
      
   public:
      TimeCheckerYielder(){timeChecker=new TimeSectionChecker;};
      ~TimeCheckerYielder(){};
      TimeSectionChecker *GetAllTimeChecker()
      {
         timeChecker.InitOne(AllSection);
         return timeChecker;
      };
      
      TimeSectionChecker *GetAmericanTimeChecker()
      {
         timeChecker.InitOne(AmericanSection);
         return timeChecker;
      }
      
      TimeSectionChecker *GetAsianTimeChecker()
      {
         timeChecker.InitOne(AsianSection);
         return timeChecker;
      }
      
      TimeSectionChecker *GetEuropeTimeChecker()
      {
         timeChecker.InitOne(EuropeSection);
         return timeChecker;
      }
      
      TimeSectionChecker *Get11To14And17To1TimeChecker()
      {
         Section sectionOne={TODAY,11,TODAY,14};
         Section sectionTwo={TODAY,17,TOMORROW,1};
         timeChecker.InitOne(sectionOne);
         timeChecker.InitTwo(sectionTwo);
         return timeChecker;
      }
      
      TimeSectionChecker *Get5To7TimeChecker()
      {
         Section sectionOne={TODAY,5,TODAY,7};
         timeChecker.InitOne(sectionOne);
         return timeChecker;
      }
      
      TimeSectionChecker *GetOneTimeChecker()
      {
            Section sectionOne={TODAY,1,TODAY,4};
            timeChecker.InitOne(sectionOne);
            //Section sectionThree={0,1,1,1};
            //Section sectionFour={TODAY,3,TOMORROW,3};
            //Section sectionFive={0,1,1,1};
            //Section sectionSix={TODAY,3,TOMORROW,3};
            //Section sectionSeven={0,1,1,1};
            //Section sectionEight={TODAY,3,TOMORROW,3};   
            //timeChecker.InitOne(AmericanSection);
            //timeChecker.InitTwo(sectionTwo);
            //timeChecker.InitThree(sectionThree);
            //timeChecker.InitFour(sectionFour);
            //timeChecker.InitFive(sectionFive);
            //timeChecker.InitSix(sectionSix);
            //timeChecker.InitSeven(sectionSeven);
            //timeChecker.InitEight(sectionEight);
            //timeChecker.InitNine(sectionNine);
            //timeChecker.InitTen(sectionTen);
            return timeChecker;
      }

};