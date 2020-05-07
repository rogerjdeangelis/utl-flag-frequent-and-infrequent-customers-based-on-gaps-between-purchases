Flag frequent and infrequent customers based on on gaps between purchases.                                                             
                                                                                                                                       
This solution soes not just flag the last purchase when any gap in the custormer's purchase history is less                            
that 5 years. It assigns four levels for purchases.                                                                                    
                                                                                                                                       
github                                                                                                                                 
https://tinyurl.com/yalov442                                                                                                           
https://github.com/rogerjdeangelis/utl-flag-frequent-and-infrequent-customers-based-on-gaps-between-purchases                          
                                                                                                                                       
RULES                                     Flag      Algorithm                                                                          
                                                                                                                                       
  If New Customer Single Purchase           1       first.purchase and last.purchase                                                   
  If New Customer Multiple Purchases        0       first.purchase but not last                                                        
  If Infrequent Purchase (gap > 5 years)    2       purchase gap >  5 years                                                            
  If Frequent Purchase (gap <=  5 years)    3       purchase gap <= 5 years                                                            
                                                                                                                                       
*_                   _                                                                                                                 
(_)_ __  _ __  _   _| |_                                                                                                               
| | '_ \| '_ \| | | | __|                                                                                                              
| | | | | |_) | |_| | |_                                                                                                               
|_|_| |_| .__/ \__,_|\__|                                                                                                              
        |_|                                                                                                                            
;                                                                                                                                      
                                                                                                                                       
SAs Forum (realted to but not the same problem)                                                                                        
https://tinyurl.com/y82kl3xa                                                                                                           
https://communities.sas.com/t5/SAS-Programming/How-to-flag-a-customer-based-on-previous-5-yr-rolling-sales/m-p/645826                  
                                                                                                                                       
Related to Kurt's solution                                                                                                             
Kurt Breser                                                                                                                            
https://tinyurl.com/y82kl3xa                                                                                                           
                                                                                                                                       
data have ;                                                                                                                            
  input CUSTOMER_ID $ Sale_Date : mmddyy10.;                                                                                           
  format sale_date mmddyy10.;                                                                                                          
cards4;                                                                                                                                
A 02/03/2010                                                                                                                           
A 03/05/2013                                                                                                                           
A 01/11/2019                                                                                                                           
B 06/08/2017                                                                                                                           
B 04/08/2019                                                                                                                           
C 05/29/2010                                                                                                                           
C 06/29/2017                                                                                                                           
D 07/19/2010                                                                                                                           
;;;;                                                                                                                                   
run;quit;                                                                                                                              
                                                                                                                                       
                                                                                                                                       
WORK.HAVE total obs=8                                                                                                                  
                         | RULES                                                                                                       
 CUSTOMER_               | =====                                                                                                       
    ID        SALE_DATE  |    FLG  YERDIF    DES                                                                                       
                         |                                                                                                             
     A        02/03/2010 |     0             New Customer                                                                              
     A        03/05/2013 |     3       3     Frequent Purchase                                                                         
     A        01/11/2019 |     3       5     Frequent Purchase                                                                         
                                                                                                                                       
     B        06/08/2017 |     0             New Customer                                                                              
     B        04/08/2019 |     3       1     Frequent Purchase                                                                         
                                                                                                                                       
     C        05/29/2010 |     0             New Customer                                                                              
     C        06/29/2017 |     2       7     Infrequent Purchase                                                                       
                                                                                                                                       
     D        07/19/2010 |     1             Single Purchase                                                                           
                         |                                                                                                             
*            _               _                                                                                                         
  ___  _   _| |_ _ __  _   _| |_                                                                                                       
 / _ \| | | | __| '_ \| | | | __|                                                                                                      
| (_) | |_| | |_| |_) | |_| | |_                                                                                                       
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                      
                |_|                                                                                                                    
;                                                                                                                                      
                                                                                                                                       
WANT total obs=8                                                                                                                       
                                                                                                                                       
       CUSTOMER_                                                                                                                       
Obs       ID        SALE_DATE     YERDIF    FLG    DES                                                                                 
                                                                                                                                       
 1         A        02/03/2010      310      0     New Customer                                                                        
 2         A        03/05/2013        3      3     Frequent Purchase                                                                   
 3         A        01/11/2019        5      3     Frequent Purchase                                                                   
 4         B        06/08/2017       -2      0     New Customer                                                                        
 5         B        04/08/2019        1      3     Frequent Purchase                                                                   
 6         C        05/29/2010       -9      0     New Customer                                                                        
 7         C        06/29/2017        7      2     Infrequent Purchase                                                                 
 8         D        07/19/2010       -7      1     Single Purchase                                                                     
                                                                                                                                       
*          _       _   _                                                                                                               
 ___  ___ | |_   _| |_(_) ___  _ __                                                                                                    
/ __|/ _ \| | | | | __| |/ _ \| '_ \                                                                                                   
\__ \ (_) | | |_| | |_| | (_) | | | |                                                                                                  
|___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                                                  
                                                                                                                                       
;                                                                                                                                      
                                                                                                                                       
data want ;                                                                                                                            
                                                                                                                                       
 set have;                                                                                                                             
 by customer_id;                                                                                                                       
                                                                                                                                       
 yerDif=intck('year',coalesce(lag(sale_date),'01JAN1700'd),sale_date,'c');                                                             
                                                                                                                                       
 select;                                                                                                                               
    when (first.customer_id and last.customer_id) do; flg=1; des="Single Purchase     " ; end;                                         
    when (first.customer_id                     ) do; flg=0; des="New Customer        " ; end;                                         
    when (yerDif >  5                           ) do; flg=2; des="Infrequent Purchase " ; end;                                         
    when (yerDif <= 5                           ) do; flg=3; des="Frequent Purchase   " ; end;                                         
    /* leave off otherwise to confirm all cases have been identified - error otherwise */                                              
 end;                                                                                                                                  
                                                                                                                                       
run;                                                                                                                                   
                                                                                                                                       
