%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lumi_magnet).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"lumi.sensor_magnet.aq2").
-define(Type,"sensors").
%% --------------------------------------------------------------------
%  {"sensors","8",
%           #{<<"config">> =>
%                 #{<<"battery">> => 100,<<"on">> => true,
%                   <<"reachable">> => true,<<"temperature">> => 2300},
%             <<"ep">> => 1,
%             <<"etag">> => <<"dbf413aedbe44bec3ed17a5736bf4ba6">>,
%             <<"lastannounced">> => null,
%             <<"lastseen">> => <<"2023-11-01T20:19Z">>,
%             <<"manufacturername">> => <<"LUMI">>,
%             <<"modelid">> => <<"lumi.sensor_magnet.aq2">>,
%             <<"name">> => <<"lumi_magnet_1">>,
%             <<"state">> =>
%                 #{<<"lastupdated">> => <<"2023-11-01T20:19:55.142">>,
%                   <<"open">> => true},
%             <<"swversion">> => <<"20161128">>,
%             <<"type">> => <<"ZHAOpenClose">>,
%             <<"uniqueid">> => <<"00:15:8d:00:06:89:6d:bb-01-0006">>}},


%% External exports
-export([
	 is_reachable/3,
	 is_open/3
	]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:start{/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_reachable(_PhosconApp,[],[{_Type,_NumId,Map}|_])->
    ConfigMap=maps:get(<<"config">>,Map),
    {ok,maps:get(<<"reachable">>,ConfigMap)}.
	   
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_open(_PhosconApp,[],[{_Type,_NumId,Map}|_])->
    ConfigMap=maps:get(<<"config">>,Map),
    case maps:get(<<"reachable">>,ConfigMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    StateMap=maps:get(<<"state">>,Map),
	    {ok,maps:get(<<"open">>,StateMap)}
    end.


%% ====================================================================
%% Internal functions
%% ====================================================================
	    
    
