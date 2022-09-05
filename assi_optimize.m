% Author :  ROHIT BAGDI
% date :    08 jan 2022
% Tital :   Backwardf and Forward Sweep Load Flow Algorithm
% forward backward sweep mathod for calculation of voltage

% data for 33-bus system
%{
basemva =100 ; accuracy = 0.0001; maxiter=100; 
basekv=12.66;

% Distribution System data (33 bus system)
%            Bus    Bus     Voltage     Angle    Load    Load
%            no.    code       mag.   (degree)   (kW)   (kVAR)
%                              (pu)               
busdata=[   1       1           1       0        0       0
            2       0           1       0        100    60
            3       0           1       0        90     40
            4       0           1       0       120     80
            5       0           1       0       60      30
            6       0           1       0       60      20
            7       0           1       0       200     100
            8       0           1       0       200     100
            9       0           1       0       60      20
            10      0           1       0       60      20
            11      0           1       0       45      30
            12      0           1       0       60      35
            13      0           1       0       60      35
            14      0           1       0       120     80
            15      0           1       0       60      10
            16      0           1       0       60      20
            17      0           1       0       60      20
            18      0           1       0       90      40
            19      0           1       0       90      40
            20      0           1       0       90      40
            21      0           1       0       90      40
            22      0           1       0       90      40
            23      0           1       0       90      50
            24      0           1       0       420     200
            25      0           1       0       420     200
            26      0           1       0       60      25
            27      0           1       0       60      25
            28      0           1       0       60      20
            29      0           1       0       120     70
            30      0           1       0       200     600
            31      0           1       0       150      70
            32      0           1       0       210     100
            33      0           1       0       60      40];
        %line data are
        %   ns      nr      R       X            lineno
linedata= [ 1       2   0.0922      0.047           1
            2       3   0.493       0.2511          2
            3       4   0.366       0.1864          3
            4       5   0.3811      0.1941          4
            5       6   0.819       0.707           5
            6       7   0.1872      0.6188          6
            7       8   0.7114      0.2351          7
            8       9   1.03        0.74            8
            9       10  1.044       0.74            9
            10      11  0.1966      0.065           10
            11      12  0.3744      0.1238          11
            12      13  1.468       1.155           12
            13      14  0.5416      0.7129          13
            14      15  0.591       0.526           14
            15      16  0.7463      0.545           15
            16      17  1.289       1.721           16
            17      18  0.732       0.574           17
            2       19  0.164       0.1565          18
            19      20  1.5042      1.3554          19
            20      21  0.4095      0.4784          20
            21      22  0.7089      0.9373          21
            3       23  0.4512      0.3083          22
            23      24  0.898       0.7091          23
            24      25  0.896       0.7011          24
            6       26  0.203       0.1034          25
            26      27  0.2842      0.1447          26
            27      28  1.059       0.9337          27
            28      29  0.8042      0.7006          28
            29      30  0.5075      0.2585          29
            30      31  0.9744      0.963           30
            31      32  0.3105      0.3619          31
            32      33  0.341       0.5302          32];          

%}

%{
% data for 52-bus system
basemva =1 ; accuracy = 0.0001; maxiter=100; 
basekv=11;

% Distribution System data (52 bus system)
%           Bus   Bus       Voltage   Angle       Load    Load
%           No.   code      mag.      (Degree)    (kW)    (kVAR)
%                  (pu)

busdata=[ 1         1       1           0           0        0
          2         0       1           0           81      39
          3         0       1           0           135     65
          4         0       1           0           108     52
          5         0       1           0           108     52
          6         0       1           0           27      13
          7         0       1           0           54      26
          8         0       1           0           135     65
          9         0       1           0           81      39
          10        0       1           0           67      32
          11        0       1           0           27      13
          12        0       1           0           27      13
          13        0       1           0           108     52
          14        0       1           0           54      26
          15        0       1           0           94      45
          16        0       1           0           67      33
          17        0       1           0           67      33
          18        0       1           0           108     52
          19        0       1           0           81      39
          20        0       1           0           108     52
          21        0       1           0           94      46
          22        0       1           0           81      39
          23        0       1           0           108     52
          24        0       1           0           108     52
          25        0       1           0           102     50
          26        0       1           0           41      20
          27        0       1           0           108     52
          28        0       1           0           162     79
          29        0       1           0           68      33
          30        0       1           0           68      33
          31        0       1           0           95      46
          32        0       1           0           41      20
          33        0       1           0           121     59
          34        0       1           0           41      20
          35        0       1           0           41      20
          36        0       1           0           135     66
          37        0       1           0           81      40
          38        0       1           0           68      33
          39        0       1           0           95      46
          40        0       1           0           108     52
          41        0       1           0           41      20
          42        0       1           0           95      46
          43        0       1           0           27      13
          44        0       1           0           122     59
          45        0       1           0           108     52
          46        0       1           0           81      39
          47        0       1           0           68      33
          48        0       1           0           41      20
          49        0       1           0           68      33
          50        0       1           0           81      39
          51        0       1           0           108     52
          52        0       1           0           41      20  ];
      
 %          ns      nr      R(pu)           X (pu)      lineno
linedata= [ 1       2       0.0258          0.0111          1
            2       3       0.043           0.0185          2
            2       4       0.0129          0.0056          3
            4       5       0.0129          0.0056          4
            4       6       0.0086          0.0037          5
            6       7       0.0172          0.0074          6
            6       8       0.0215          0.0093          7
            8       9       0.0258          0.0111          8
            9       10      0.043           0.0185          9
            10      11      0.0129          0.0056          10
            11      12      0.0086          0.0037          11
            11      15      0.043           0.0185          12
            12      13      0.0301          0.013           13
            12      14      0.0344          0.0148          14
            10      16      0.0129          0.0056          15
            16      17      0.0516          0.0222          16
            16      18      0.043           0.0185          17
            18      19      0.0344          0.0148          18
            1       20      0.0086          0.0037          19
            20      21      0.0129          0.0056          20
            21      22      0.0258          0.0111          21
            22      23      0.043           0.0185          22
            23      24      0.0215          0.0093          23
            22      25      0.0258          0.0111          24
            25      26      0.0344          0.0148          25
            20      27      0.0086          0.0037          26
            27      28      0.0129          0.0056          27
            28      29      0.0215          0.0093          28
            27      30      0.0344          0.0148          29
            30      31      0.043           0.0185          30
            1       32      0.0344          0.0148          31
            32      33      0.043           0.0185          32
            33      34      0.0344          0.0148          33
            33      35      0.0301          0.013           34
            35      36      0.0344          0.0148          35
            36      37      0.0215          0.0093          36
            35      38      0.0172          0.0074          37
            33      39      0.0215          0.0093          38
            39      40      0.0172          0.0074          39
            39      41      0.0215          0.0093          40
            41      42      0.0258          0.0111          41
            41      43      0.0387          0.0167          42
            43      44      0.043           0.0185          43
            41      45      0.0129          0.0056          44
            45      46      0.0301          0.013           45
            45      47      0.0215          0.0093          46
            47      48      0.0129          0.0056          47
            47      49      0.0129          0.0056          48
            49      50      0.0344          0.0148          49
            49      51      0.0129          0.0056          50
            51      52      0.0086          0.0037          51];
%}



% data for 69-bus system
basemva =10 ; accuracy = 0.0001; maxiter=100; 
basekv=12.66;
%Distribution System data (69 bus system)
%       Bus   Bus     Voltage         Angle       Load    Load
%       no.   code    mag.(pu)        (degree)    (kW)    (kVAR)
busdata=[1      1       1               0           0       0
         2      0       1               0           0       0
         3      0       1               0           0       0
         4      0       1               0           0       0
         5      0       1               0           0       0
         6      0       1               0           2.6     2.2
         7      0       1               0           40.4    30
         8      0       1               0           75      54
         9      0       1               0           30      22
        10      0       1               0           28      19
        11      0       1               0           145     104
        12      0       1               0           145     104
        13      0       1               0           8       5.5
        14      0       1               0           8       5.5
        15      0       1               0           0       0
        16      0       1               0           45.5    30
        17      0       1               0           60      35
        18      0       1               0           60      35
        19      0       1               0           0       0
        20      0       1               0           1       0.6
        21      0       1               0           114     81
        22      0       1               0           5.3     3.5
        23      0       1               0           0       0
        24      0       1               0           28      20
        25      0       1               0           0       0
        26      0       1               0           14      10
        27      0       1               0           14      10
        28      0       1               0           26      18.6
        29      0       1               0           26      18.6
        30      0       1               0            0      0
        31      0       1               0            0      0
        32      0       1               0            0      0
        33      0       1               0           14      10
        34      0       1               0           19.5    14
        35      0       1               0           6       4
        36      0       1               0           26      18.55
        37      0       1               0           26      18.55
        38      0       1               0           0       0
        39      0       1               0           24      17
        40      0       1               0           24      17
        41      0       1               0           1.2     1
        42      0       1               0           0       0
        43      0       1               0           6       4.3
        44      0       1               0           0       0
        45      0       1               0           39.22   26.3
        46      0       1               0           39.22   26.3
        47      0       1               0           0       0
        48      0       1               0           79      56.4
        49      0       1               0           384.7   274.5
        50      0       1               0           384.7   274.5
        51      0       1               0           40.5    28.3
        52      0       1               0           3.6     2.7
        53      0       1               0           4.35    3.5
        54      0       1               0           26.4     19
        55      0       1               0           24      17.2
        56      0       1               0           0       0
        57      0       1               0           0       0
        58      0       1               0           0       0
        59      0       1               0           100     72
        60      0       1               0           0       0
        61      0       1               0           1244    888
        62      0       1               0           32      23
        63      0       1               0           0       0
        64      0       1               0           227     162
        65      0       1               0           59      42
        66      0       1               0           18      13
        67      0       1               0           18      13
        68      0       1               0           28      20
        69      0       1               0           28      20 ];
    
    %        ns     nr      R           X            lineno
linedata = [1       2       0.0005      0.0012         1 
            2       3       0.0005      0.0012         2
            3       4       0.0015      0.0036         3
            4       5       0.0251      0.0294         4 
            5       6       0.366       0.1864         5
            6       7       0.3811      0.1941         6
            7       8       0.0922      0.047          7 
            8       9       0.0493      0.0251         8 
            9       10      0.819       0.2707         9 
            10      11      0.1872      0.0691         10 
            11      12      0.7114      0.2351         11 
            12      13      1.03        0.34           12 
            13      14      1.044       0.345          13 
            14      15      1.058       0.3496         14 
            15      16      0.1966      0.065          15 
            16      17      0.3744      0.1238         16 
            17      18      0.0047      0.0016         17 
            18      19      0.3276      0.1083         18 
            19      20      0.2106      0.0696         19 
            20      21      0.3416      0.1129         20 
            21      22      0.014       0.0046         21    
            22      23      0.1591      0.0526         22 
            23      24      0.3463      0.1145         23 
            24      25      0.7488      0.2745         24 
            25      26      0.3089      0.1021         25 
            26      27      0.1732      0.0572         26 
            3       28      0.0044      0.0108         27 
            28      29      0.064       0.1565         28 
            29      30      0.3978      0.1315         29 
            30      31      0.0702      0.0232         30 
            31      32      0.351       0.116          31 
            32      33      0.839       0.2816         32 
            33      34      1.708       0.5646         33 
            34      35      1.474       0.4873         34 
            3       36      0.0044      0.0108         35 
            36      37      0.064       0.1565         36 
            37      38      0.1053      0.123          37 
            38      39      0.0304      0.0355         38 
            39      40      0.0018      0.0021         39 
            40      41      0.7283      0.8509         40 
            41      42      0.31        0.3623         41 
            42      43      0.041       0.0478         42 
            43      44      0.0092      0.0116         43 
            44      45      0.1089      0.1373         44 
            45      46      0.0009      0.0012         45 
            4       47      0.0034      0.0084         46 
            47      48      0.0851      0.2083         47 
            48      49      0.2898      0.7091         48 
            49      50      0.0822      0.2011         49 
            8       51      0.0928      0.0473         50 
            51      52      0.3319      0.1114         51 
            9       53      0.174       0.0886         52 
            53      54      0.203       0.1034         53 
            54      55      0.2842      0.1447         54 
            55      56      0.2813      0.1433         55 
            56      57      1.59        0.5337         56 
            57      58      0.7837      0.263          57 
            58      59      0.3042      0.1006         58
            59      60      0.3861      0.1172         59 
            60      61      0.5075      0.2585         60 
            61      62      0.0974      0.0496         61 
            62      63      0.145       0.0738         62 
            63      64      0.7105      0.3619         63 
            64      65      1.041       0.5302         64 
            11      66      0.2012      0.0611         65 
            66      67      0.0047      0.0014         66 
            12      68      0.7394      0.2444         67 
            68      69      0.0047      0.0016         68 ];
 

  


% imaginary no.        
    j=sqrt(-1);
% BASE IMPEDANECE
 z_base= basekv^2/basemva;
% INITIALIZATION SAME VARIABLE AND BUS_CURRENT BY ZERO 
 end_point=0;
 load_current=0;
 bus_current=zeros(length(busdata(:,1)),2);
% IN GIVEN SIMULATION  FOR 52-BUS SYSTEM R,X ARE IN P.U 
 % change impedence in p.u
 if length(busdata(:,1))==52        % for 52-bus system no need to change in p.u
 z=zeros(length(linedata(:,1)),3);
 z(:,1)=linedata(:,1);
 z(:,2)=linedata(:,2);
 z(:,3)=linedata(:,3)+j*linedata(:,4);
 else
 z=zeros(length(linedata(:,1)),3);
 z(:,1)=linedata(:,1);
 z(:,2)=linedata(:,2);
 z(:,3)=linedata(:,3)/z_base+j*linedata(:,4)/z_base;
 end
 
 
 % change power in p.u.
 P=busdata(:,5)/(basemva*1000);
 Q=busdata(:,6)/(basemva*1000);
 
 %Q(30)=Q(30)-1254/(basemva*1000);
 
 % for svc designing
 %Q(bus_for_Q) = Q(bus_for_Q)-injected_Q;
 
 % CREATING THE VALUE OF VLT_NEW AND VLT_OLD
 Vlt_new=busdata(:,3);
 Vlt_old=busdata(:,3);
 
 % CODE FOR FINDING END POINTS
 count=1;
 for line_no=length(linedata)+1:-1:1
     
     if line_no<length(linedata)
        if linedata(line_no+1,1)~=linedata(line_no,2)
            end_point(count)=linedata(line_no,2);
            count=count+1;
        end
     end
     if line_no==length(linedata)+1
         end_point(count)=length(linedata)+1;
         count=count+1;
     end
 end

 actual_Q=Q;
 
 for bus_for_Q=1:length(busdata(:,1))-1

     bus_for_Q=bus_for_Q+1;
        new_power=0;
        old_power=0;
        injected_Q=0;
        power_error=0;
        plot_iter=0;
        plot_ploss=0;
        plot_Q=0;
        Q=actual_Q;
        max_v_err_r=1;
        no_iter=0;
        Iline=0;

        Q=actual_Q;

    while power_error<=0
        old_power=new_power;

%------------------------ code for F_B_SWEEP-------------------------------
%--------------------------------------------------------------------------


        max_v_err_r=1;
        no_iter=0;
        Iline=0;

        while max_v_err_r>=0.0001 & no_iter < maxiter                          
 Vlt_old=Vlt_new;
 bus_current=zeros(length(busdata(:,1)),2);
 
    %load current at each bus
    for i=1:length(linedata)+1
        load_current(i,1)=(P(i)-j*Q(i))/conj (Vlt_new(i,1));
        
    end
 

 % finding the line or bus current
    for i=1:length(end_point)
     endbus = end_point(i);
        for k= endbus:-1:1
         p=k;
         if p>0
             
         if p== endbus                          % for end point bus current 
            bus_current(p,1)=k;
            bus_current(p,2)=bus_current(p,2)+load_current(p);
         else 
        if linedata(p,1)== linedata(p,2)-1      % for the connection exist between 2 bus 
            
            present_bus=linedata(p,1);
            next_bus=linedata(p,2);
            
            bus_current(present_bus,1) = present_bus;
            bus_current(present_bus,2) = bus_current(present_bus,2)+load_current(present_bus) + bus_current(next_bus,2);
        else
                                                
            present_bus=linedata(p,1);
            next_bus=linedata(p,2);
            
            bus_current(present_bus,1)=present_bus;
            bus_current(present_bus,2)=bus_current(present_bus,2)+bus_current(next_bus,2);
            
            break 
        end
         end
         end 
        end
    end
 
    for point=1:length(linedata(:,1))
        
        starting_node=linedata(point,1);
        ending_node=linedata(point,2);
        lineno=linedata(point,5);
        Vlt_new(ending_node,1)=Vlt_new(starting_node,1)-bus_current(lineno+1,2)*z(point,3);
        
    end
     error=Vlt_new-Vlt_old;
   
     max_v_err_r=max(abs(error));
     busdata(:,3)=abs(Vlt_new);
     
     no_iter=no_iter+1;
     
end


        Ploss=0;

  for point=1:length(linedata(:,1))
        
        lineno=linedata(point,5);
        Ploss=Ploss+abs(bus_current(lineno+1,2))^2*real(z(point,3));
       
        
  end
%---------------------------------- finish the----------------------------
%code----------------------------------------------------------------------


        new_power=Ploss;
        if(injected_Q==0)
            power_error=0;
        else
            power_error=new_power-old_power;
        end

     plot_iter=plot_iter+1;
     plot_ploss(plot_iter)=new_power;
     plot_Q(plot_iter)=injected_Q;

     injected_Q=injected_Q+1/(basemva*1000);
     Q(bus_for_Q) = actual_Q(bus_for_Q)-injected_Q;
     disp("the data for operation bus no " +bus_for_Q + " value of q " +Q +" injected_Q "+injected_Q + "error "+power_error);

    end
 powerloss(bus_for_Q)=old_power*basemva*1000;
 qforminloss(bus_for_Q)=injected_Q*basemva*1000;
 
 figure(2)
    plot(plot_Q*basemva*1000,plot_ploss*basemva*1000),
    
    hold on
    
 end

 figure(2)
xlabel("C in KVAR"), ylabel('Ploss in KW'),title("Ploss in KW Vs C in KVAR");


 minipowerloss=powerloss(2);
     position=0;
 for i=2:length(busdata(:,1))
    if(minipowerloss>=powerloss(i))
        minipowerloss=powerloss(i);
        position=i;
    else
        
    end
 end

 disp("minimum power loss  "+minipowerloss+" value of q "+qforminloss(position));
 