%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50 
%%% @doc
%%%
%%% @end
%%% Created : 25 Oct 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(lib_zigbee_server). 

-include("device.hrl").
-define(ZigbeeController,phoscon_server).

%% API
-export([
	 get_all/0,
	 get_all/1,
	 get_all/2,
	 get_all_raw/1,	 
	 get_num_map_module/2,
	 get_module/2,

	 call/4,

	 all/0,

	 present/0
	]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Needed Information : phoscon = zigbee controller/hub, DeviceName= Type and Id
%% Function Args   
%% @end
%%--------------------------------------------------------------------
get_all(PhosconApp,DeviceType)->
    case rd:fetch_resources(PhosconApp) of
	[]->
	    {error,["No resources for ",PhosconApp]};
	[{_,Node}] ->
	    case rpc:call(Node,phoscon_server,get_maps,[DeviceType],5000) of
		{error,Reason}->
		    {error,[Reason,?MODULE,?LINE]};
		{ok,TypeMaps}->
		    {ok,get_info([{DeviceType,{ok,TypeMaps}}],[])}
	    end
    end.

%%--------------------------------------------------------------------
%% @doc
%% Needed Information : phoscon = zigbee controller/hub, DeviceName= Type and Id
%% Function Args   
%% @end
%%--------------------------------------------------------------------
get_all(PhosconApp)->
    case rd:fetch_resources(PhosconApp) of
	[]->
	    {error,["No resources for ",PhosconApp]};
	[{_,Node}] ->
	    case rpc:call(Node,phoscon_server,get_maps,[],5000) of
		{error,Reason}->
		    {error,[Reason,?MODULE,?LINE]};
		TypeMaps->
		    {ok,get_info(TypeMaps,[])}
	    end
    end.
%%--------------------------------------------------------------------
%% @doc
%% Needed Information : phoscon = zigbee controller/hub, DeviceName= Type and Id
%% Function Args   
%% @end
%%--------------------------------------------------------------------
get_all()->
    case rd:fetch_resources(?ZigbeeController) of
	[]->
	    {error,["No resources for ",?ZigbeeController]};
	[{_,Node}] ->
	    case rpc:call(Node,phoscon_server,get_maps,[],5000) of
		{error,Reason}->
		    {error,[Reason,?MODULE,?LINE]};
		TypeMaps->
		     {ok,get_info(TypeMaps,[])}
	    end
    end.

%%--------------------------------------------------------------------
%% @doc
%% Needed Information : phoscon = zigbee controller/hub, DeviceName= Type and Id
%% Function Args   
%% @end
%%--------------------------------------------------------------------
call(PhosconApp,DeviceName,Function,Args)->
    case  get_num_map_module(PhosconApp,DeviceName) of
	{error,Reason}->
	    {error,Reason};
	{ok,Module,ListTypeNumIdMap}->
	    rpc:call(node(),Module,Function,[PhosconApp,Args,ListTypeNumIdMap],5000)
		
    end.


%%-------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
get_num_map_module(PhosconApp,Name)->
    case get_all_raw(PhosconApp) of
	{error,Reason}->
	    {error,["No Maps available ,Name, Reason",Name, Reason, ?MODULE,?LINE]};
	{ok,AllMaps}->
	    TYpeNumIdMapList= [{Type,NumId,Map}||{Type,NumId,Map}<-AllMaps,
						 Name=:=binary_to_list(maps:get(<<"name">>,Map))],
	    case TYpeNumIdMapList of
		[]->
		    {error,["Name not found",Name,?MODULE,?LINE]};
		ListTypeNumIdMap->
		    [{Type,NumId,Map}|_]=ListTypeNumIdMap,
		    ModelId=binary_to_list(maps:get(<<"modelid">>,Map)),
						% [Module]=[maps:get(module,DeviceMap)||DeviceMap<-?DeviceInfo,
		    ModuleInList=[maps:get(module,DeviceMap)||DeviceMap<-?DeviceInfo,
							      ModelId=:=maps:get(modelid,DeviceMap)],
						%   ModuleInList=test_get_module(?DeviceInfo,ModelId,false,na),
		    case ModuleInList of
			[]->
			    {error,["Module not identfied Name,ModelId,Type,NumId,Map ",Name,ModelId,Type,NumId,Map]};
			[Module]->
			    {ok,Module,ListTypeNumIdMap}
		    end
	    end
    end.

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
get_module(DeviceMaps,ModelId)->
    get_module(DeviceMaps,ModelId,false,undefined).

get_module([],ModelId,false,_Module)->
    {error,["Not found ",ModelId]};
get_module(_,_ModelId,true,Module)->
    Module;
get_module([DeviceMap|T],ModelId,false,_)->
    case ModelId=:=maps:get(modelid,DeviceMap) of
	true->
	    Found=true,
	    Module=[maps:get(module,DeviceMap)];
	false ->
	    Found=false,
	    Module=na
    end,
    get_module(T,ModelId,Found,Module).
%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
present()->
    


    ok.


%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
get_all_raw(PhosconApp)->
    case rd:fetch_resources(PhosconApp) of
	[]->
	    {error,["No resources for ",PhosconApp]};
	[{_,Node}] ->
	    case rpc:call(Node,phoscon_server,get_maps,[],5000) of
		{error,Reason}->
		    {error,[Reason,?MODULE,?LINE]};
		TypeMaps->
		    {ok,get_info_raw(TypeMaps,[])}
	    end
    end.

%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
all()->
    Result=case rd:call(phoscon,get_maps,[],5000) of
	       {error,Reason}->
		   {error,[Reason,?MODULE,?LINE]};
	       TypeMaps->
		   get_info(TypeMaps,[])
	   end,
    Result.



%%%===================================================================
%%% Internal functions
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
get_info_raw([],Acc)->
    lists:append(Acc);
get_info_raw([{Type,{ok,Map}}|T],Acc)->
    L=maps:to_list(Map),
    AllMaps=format_info_raw(L,Type,[]),
    get_info_raw(T,[AllMaps|Acc]).

format_info_raw([],_Type,Acc)->
    Acc;
format_info_raw([{NumIdBin,Map}|T],Type,Acc)->
    NumId=binary_to_list(NumIdBin),
    format_info_raw(T,Type,[{Type,NumId,Map}|Acc]).
%%--------------------------------------------------------------------
%% @doc
%%  
%% @end
%%--------------------------------------------------------------------
get_info([],Acc)->
    lists:append(Acc);
get_info([{Type,{ok,Map}}|T],Acc)->
    L=maps:to_list(Map),
    AllInfo=format_info(L,Type,[]),
    get_info(T,[AllInfo|Acc]).
    
format_info([],_Type,Acc)->
    Acc;
format_info([{NumIdBin,Map}|T],Type,Acc)->
    NumId=binary_to_list(NumIdBin),
    Name=binary_to_list(maps:get(<<"name">> ,Map)),
    ModelId=binary_to_list(maps:get(<<"modelid">>,Map)),
    format_info(T,Type,[{Type,NumId,Name,ModelId}|Acc]).


	   
