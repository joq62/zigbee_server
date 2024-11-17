%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%%
%%% -------------------------------------------------------------------
-module(all).       
 
-export([start/0]).


-define(PhosconApp,phoscon_server).
-define(Appl,zigbee_server).
-define(TestAppl,test_zigbee_server).

%%---------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
   
    ok=setup(),
    timer:sleep(2*5000),
 %   ok=test1(),
 %   ok=test2(),
 %   ok=test3(),
    ok=test_sensors(),
    io:format("Test OK !!! ~p~n",[?MODULE]),
    timer:sleep(2000),
    init:stop(),
    ok.

%%-----------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_sensors()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),

    
    %% Weather
    {ok,true}=zigbee_server:call(?PhosconApp,"weather_2",is_reachable,[]),
    {ok,TempFloat}=zigbee_server:call(?PhosconApp,"weather_2",temp,[]),
    Temp=lists:flatten(float_to_list(TempFloat,[{decimals, 1}])," °C"),
    io:format("Temp = ~p~n",[Temp]),
    {ok,HumidityFloat}=zigbee_server:call(?PhosconApp,"weather_2",humidity,[]),
    Humidity=lists:flatten(float_to_list(HumidityFloat,[{decimals, 1}])," %"),
    io:format("Humidity = ~p~n",[Humidity]),
    {ok,PressureFloat}=zigbee_server:call(?PhosconApp,"weather_2",pressure,[]),
    Pressure=lists:flatten(integer_to_list(PressureFloat)," hPa"),
    io:format("Pressure = ~p~n",[Pressure]),
    
    % Motion
    {ok,true}=zigbee_server:call(?PhosconApp,"motion_test",is_reachable,[]),
    
    % Vibration
     {ok,true}=zigbee_server:call(?PhosconApp,"vibration_test",is_reachable,[]),
  
     % Door sensor
    {ok,true}=zigbee_server:call(?PhosconApp,"door_test",is_reachable,[]),
    ok.
%%-----------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test3()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),

       
    {ok,true}=zigbee_server:call(?PhosconApp,"On-Off-plug-book-shelf",is_reachable,[]),
    {ok,"off"}=zigbee_server:call(?PhosconApp,"On-Off-plug-book-shelf",turn_off,[]),
    {ok,true}=zigbee_server:call(?PhosconApp,"On-Off-plug-book-shelf",is_off,[]),
    {ok,false}=zigbee_server:call(?PhosconApp,"On-Off-plug-book-shelf",is_on,[]),
    {ok,"on"}=zigbee_server:call(?PhosconApp,"On-Off-plug-book-shelf",turn_on,[]),
    timer:sleep(2000),
    {ok,false}=zigbee_server:call(?PhosconApp,"On-Off-plug-book-shelf",is_off,[]),
    {ok,true}=zigbee_server:call(?PhosconApp,"On-Off-plug-book-shelf",is_on,[]),
    {ok,"off"}=zigbee_server:call(?PhosconApp,"On-Off-plug-book-shelf",turn_off,[]),
    
ok.
%%-----------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test2()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    {ok,Lights}=zigbee_server:get_all(?PhosconApp,"lights"),
    [{"lights","1","Configuration tool 1","ConBee II"},{"lights","10","On-Off-plug-book-shelf","TRADFRI control outlet"},{"lights","11","lamp-window-balcony","TRADFRIbulbE14WScandleopal470lm"},
     {"lights","12","On-Off-plug-asa-bedroom","TRADFRI control outlet"},{"lights","13","On/Off plug-vitrin-skap","TRADFRI control outlet"},{"lights","2","lamp_livingroom_small_board","TRADFRI bulb E27 WW 806lm"},
     {"lights","3","On-Off-plug-joaki-bedroom","TRADFRI control outlet"},{"lights","4","lamp_livingroom_floor","TRADFRI bulb E27 WW 806lm"},
     {"lights","5","outlet_switch_tv","TRADFRI control outlet"},{"lights","6","lamp_hall_strindberg","TRADFRIbulbE14WScandleopal470lm"},
     {"lights","7","On-Off-plug-kitchen-lamp","TRADFRI control outlet"},{"lights","8","lamp_table_kitchen","TRADFRI control outlet"},
     {"lights","9","On-Off-plug-balcony","TRADFRI control outlet"}
    ]=lists:sort(Lights),

    {ok,Switches}=zigbee_server:get_all(?PhosconApp,"switches"),
    [{"switches","1","Configuration tool 1","ConBee II"},{"switches","10","On-Off-plug-book-shelf","TRADFRI control outlet"},
     {"switches","11","lamp-window-balcony","TRADFRIbulbE14WScandleopal470lm"},{"switches","12","On-Off-plug-asa-bedroom","TRADFRI control outlet"},
     {"switches","13","On/Off plug-vitrin-skap","TRADFRI control outlet"},
     {"switches","2","lamp_livingroom_small_board","TRADFRI bulb E27 WW 806lm"},
     {"switches","3","On-Off-plug-joaki-bedroom","TRADFRI control outlet"},
     {"switches","4","lamp_livingroom_floor","TRADFRI bulb E27 WW 806lm"},
     {"switches","5","outlet_switch_tv","TRADFRI control outlet"},
     {"switches","6","lamp_hall_strindberg","TRADFRIbulbE14WScandleopal470lm"},
     {"switches","7","On-Off-plug-kitchen-lamp","TRADFRI control outlet"},{"switches","8","lamp_table_kitchen","TRADFRI control outlet"},
     {"switches","9","On-Off-plug-balcony","TRADFRI control outlet"}
    ]=lists:sort(Switches),
    ok.

%%-----------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test1()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    {ok,AllInfo}=zigbee_server:get_all(?PhosconApp),
    [{"lights","1","Configuration tool 1","ConBee II"},{"lights","10","On-Off-plug-book-shelf","TRADFRI control outlet"},
     {"lights","11","lamp-window-balcony","TRADFRIbulbE14WScandleopal470lm"},{"lights","12","On-Off-plug-asa-bedroom","TRADFRI control outlet"},
     {"lights","13","On/Off plug-vitrin-skap","TRADFRI control outlet"},{"lights","2","lamp_livingroom_small_board","TRADFRI bulb E27 WW 806lm"},
     {"lights","3","On-Off-plug-joaki-bedroom","TRADFRI control outlet"},{"lights","4","lamp_livingroom_floor","TRADFRI bulb E27 WW 806lm"},
     {"lights","5","outlet_switch_tv","TRADFRI control outlet"},{"lights","6","lamp_hall_strindberg","TRADFRIbulbE14WScandleopal470lm"},
     {"lights","7","On-Off-plug-kitchen-lamp","TRADFRI control outlet"},{"lights","8","lamp_table_kitchen","TRADFRI control outlet"},
     {"lights","9","On-Off-plug-balcony","TRADFRI control outlet"},{"sensors","1","Daylight","PHDL00"},
     {"sensors","10","Motion Sensor","lumi.sensor_motion.aq2"},{"sensors","11","LightLevel 11","lumi.sensor_motion.aq2"},
     {"sensors","13","On-Off-switch-kitchen-balcony","TRADFRI on/off switch"},{"sensors","14","on-off-remote-book-shelf","Remote Control N2"},
     {"sensors","16","on-off-switch-joakim-bedroom","TRADFRI on/off switch"},{"sensors","17","on-off-switch-asa-bedroom","TRADFRI on/off switch"},
     {"sensors","18","weather_2","lumi.weather"},{"sensors","19","weather_2","lumi.weather"},{"sensors","20","weather_2","lumi.weather"},
     {"sensors","21","Remote Control Vitrin-skap","Remote Control N2"},{"sensors","5","weather_1","lumi.weather"},
     {"sensors","6","weather_1","lumi.weather"},{"sensors","7","weather_1","lumi.weather"},{"sensors","8","switch_lamps","TRADFRI on/off switch"},
     {"sensors","9","switch_tv","TRADFRI on/off switch"}
    ]=lists:sort(AllInfo),
    io:format("AllInfo ~p~n",[{AllInfo,?MODULE,?FUNCTION_NAME,?LINE}]),

    ok.
%%-----------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
  
    ok=application:start(test_appl),
    pong=log:ping(),
    pong=rd:ping(),
    %% To be changed when create a new server
    pong=?Appl:ping(),

    ok.
