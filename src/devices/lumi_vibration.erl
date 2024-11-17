%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lumi_vibration).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"lumi.vibration.aq1").
-define(Type,"sensors").
%% --------------------------------------------------------------------
%{"sensors","12",
%  #{<<"config">> =>
%        #{<<"battery">> => 95,<<"on">> => true,<<"pending">> => [],
%          <<"reachable">> => true,<<"sensitivity">> => 11,
%          <<"sensitivitymax">> => 21,<<"temperature">> => 3000},
%    <<"ep">> => 1,
%    <<"etag">> => <<"ace3a3b79f76b555744d0d4abd062754">>,
%    <<"lastannounced">> => null,
%    <<"lastseen">> => <<"2023-11-02T20:31Z">>,
%    <<"manufacturername">> => <<"LUMI">>,
%    <<"modelid">> => <<"lumi.vibration.aq1">>,
%    <<"name">> => <<"vib_1">>,
%    <<"state">> =>
%        #{<<"lastupdated">> => <<"2023-11-02T20:31:09.331">>,
%          <<"orientation">> => [0,2,88],
%          <<"tiltangle">> => 360,<<"vibration">> => true,
%          <<"vibrationstrength">> => 4},
%    <<"swversion">> => <<"20180130">>,
%    <<"type">> => <<"ZHAVibration">>,
%    <<"uniqueid">> => <<"00:15:8d:00:09:1b:4e:17-01-0101">>}},

%% External exports
-export([
	 is_reachable/3,
	 has_vibrated/3
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
has_vibrated(_PhosconApp,[],[{_Type,_NumId,Map}|_])->
    ConfigMap=maps:get(<<"config">>,Map),
%    io:format("ConfigMap  ~p~n",[{ConfigMap,?MODULE,?LINE}]),
    case maps:get(<<"reachable">>,ConfigMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    StateMap=maps:get(<<"state">>,Map),
%	    io:format("StateMap  ~p~n",[{StateMap,?MODULE,?LINE}]),
	    {ok,maps:get(<<"vibration">>,StateMap)}
    end.

%% ====================================================================
%% Internal functions
%% ====================================================================

		    
    
