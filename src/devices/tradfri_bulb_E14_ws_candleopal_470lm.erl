%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(tradfri_bulb_E14_ws_candleopal_470lm).       
      
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"TRADFRIbulbE14WScandleopal470lm").
-define(Type,"lights").
%% --------------------------------------------------------------------
% {"lights","12",
%           #{<<"colorcapabilities">> => 0,<<"ctmax">> => 65279,
%             <<"ctmin">> => 0,
%             <<"etag">> => <<"9b019a96bf9573334ac69559158ccfaf">>,
%             <<"hascolor">> => true,
%             <<"lastannounced">> => <<"2023-10-18T18:55:51Z">>,
%             <<"lastseen">> => <<"2023-11-01T19:47Z">>,
%             <<"manufacturername">> => <<"IKEA of Sweden">>,
%             <<"modelid">> => <<"TRADFRIbulbE14WScandleopal470lm">>,
%             <<"name">> => <<"hall_1_of_8">>,
%             <<"state">> =>
%                 #{<<"alert">> => <<"none">>,<<"bri">> => 98,
%                   <<"colormode">> => <<"ct">>,<<"ct">> => 454,
%                   <<"on">> => true,<<"reachable">> => true},
%             <<"swversion">> => <<"1.0.032">>,
%             <<"type">> => <<"Color temperature light">>,
%             <<"uniqueid">> => <<"a4:9e:69:ff:fe:1b:b1:af-01">>}},




%% External exports
-export([
	 is_reachable/3,
	 is_on/3,
	 turn_on/3,
	 turn_off/3,
	 get_bri/3,
	 set_bri/3
	 
	]). 


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_reachable(_PhosconApp,[],[{_Type,_NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    {ok,maps:get(<<"reachable">>,StateMap)}.
	   
	   
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_on(_PhosconApp,[],[{_Type,_NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    {on,maps:get(<<"on">>,StateMap)}
    end.
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
turn_on(PhosconApp,[],[{_Type,NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    Id=NumId,
	    Key=list_to_binary("on"),
	    Value=true,
	    DeviceType=?Type,
	      case rd:fetch_resources(PhosconApp) of
		[]->
		    {error,["No resources for ",PhosconApp]};
		[{_,Node}] ->
		    case rpc:call(Node,phoscon_server,set_state,[Id,Key,Value,DeviceType],5000) of
			{ok,200,_Body,_Result}->
			    {ok,"on"};
			Error ->
			    {error,[Error]}
		    end
	      end
    end.

%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
turn_off(PhosconApp,[],[{_Type,NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    Id=NumId,
	    Key=list_to_binary("on"),
	    Value=false,
	    DeviceType=?Type,
	     case rd:fetch_resources(PhosconApp) of
		[]->
		    {error,["No resources for ",PhosconApp]};
		[{_,Node}] ->
		    case rpc:call(Node,phoscon_server,set_state,[Id,Key,Value,DeviceType],5000) of
			{ok,200,_Body,_Result}->
			    {ok,"off"};
			Error ->
			    {error,[Error]}
		    end
	      end
    end.



%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
get_bri(_PhosconApp,[],[{_Type,_NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	   {ok, maps:get(<<"bri">>,StateMap)}
    end.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
set_bri(PhosconApp,[Bri],[{_Type,NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    Id=NumId,
	    Key=list_to_binary("bri"),
	    Value=Bri,
	    DeviceType=?Type,
	     case rd:fetch_resources(PhosconApp) of
		[]->
		    {error,["No resources for ",PhosconApp]};
		[{_,Node}] ->
		    case rpc:call(Node,phoscon_server,set_state,[Id,Key,Value,DeviceType],5000) of
			{ok,200,_Body,_Result}->
			    {ok,Bri};
			Error ->
			    {error,[Error]}
		    end
	      end
    end.
