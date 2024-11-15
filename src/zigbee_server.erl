%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50
%%% @doc
%%% 
%%% @end
%%% Created : 18 Apr 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(zigbee_server). 
 
-behaviour(gen_server).
%%--------------------------------------------------------------------
%% Include 
%%
%%--------------------------------------------------------------------

-include("log.api").

%% To be changed when create a new server
-include("zigbee_server.hrl").
-include("zigbee_server.rd").
-include("device.hrl").

%% API

-export([
	 get_all/0,
	 get_all/1,
	 get_all/2,
	 get_all_raw/1,
	 call/4,
	 present/0
	 
	]).


%% admin




-export([
	 template_call/1,
	 template_cast/1,	 
	 start/0,
	 ping/0,
	 stop/0
	]).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3, format_status/2]).

-define(SERVER, ?MODULE).
		     
-record(state, {

	        
	       }).

%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec call(PhosconAppl :: atom(),DeviceName :: string(),Function :: atom(), Args :: term()) -> Result :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

call(PhosconAppl,DeviceName,Function, Args) ->
    gen_server:call(?SERVER,{call,PhosconAppl,DeviceName,Function, Args},infinity).

%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec get_all_raw(PhosconApp :: atom()) -> ListOfMaps :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

get_all_raw(PhosconApp) ->
    gen_server:call(?SERVER,{get_all_raw,PhosconApp},infinity).

%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec get_all(PhosconApp :: atom(),DeviceType :: string()) -> ListOfDeviceName :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

get_all(PhosconApp,DeviceType) ->
    gen_server:call(?SERVER,{get_all,PhosconApp,DeviceType},infinity).


%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec get_all(PhosconApp :: atom()) -> ListOfDeviceName :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

get_all(PhosconApp) ->
    gen_server:call(?SERVER,{get_all,PhosconApp},infinity).

%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec get_all() -> ListOfDeviceName :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

get_all() ->
    gen_server:call(?SERVER,{get_all},infinity).

%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec present() -> ListOfDeviceName :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

present() ->
    gen_server:call(?SERVER,{present},infinity).



%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
start()->
    application:start(?MODULE).

%%--------------------------------------------------------------------
%% @doc
%% Used to check if the application has started correct
%% @end
%%--------------------------------------------------------------------
-spec ping() -> pong | Error::term().
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).

%%--------------------------------------------------------------------
%% @doc
%% Used to check if the application has started correct
%% @end
%%--------------------------------------------------------------------
-spec template_call(Args::term()) -> {ok,Year::integer(),Month::integer(),Day::integer()} | Error::term().
template_call(Args)-> 
    gen_server:call(?SERVER, {template_call,Args},infinity).
%%--------------------------------------------------------------------
%% @doc
%% Used to check if the application has started correct
%% @end
%%--------------------------------------------------------------------
-spec template_cast(Args::term()) -> ok.
template_cast(Args)-> 
    gen_server:cast(?SERVER, {template_cast,Args}).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%% @end
%%--------------------------------------------------------------------
-spec start_link() -> {ok, Pid :: pid()} |
	  {error, Error :: {already_started, pid()}} |
	  {error, Error :: term()} |
	  ignore.
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


%stop()-> gen_server:cast(?SERVER, {stop}).
stop()-> gen_server:stop(?SERVER).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%% @end
%%--------------------------------------------------------------------
-spec init(Args :: term()) -> {ok, State :: term()} |
	  {ok, State :: term(), Timeout :: timeout()} |
	  {ok, State :: term(), hibernate} |
	  {stop, Reason :: term()} |
	  ignore.

init([]) ->
    
    {ok, #state{
	    	    
	   },0}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%% @end
%%--------------------------------------------------------------------
-spec handle_call(Request :: term(), From :: {pid(), term()}, State :: term()) ->
	  {reply, Reply :: term(), NewState :: term()} |
	  {reply, Reply :: term(), NewState :: term(), Timeout :: timeout()} |
	  {reply, Reply :: term(), NewState :: term(), hibernate} |
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: term(), Reply :: term(), NewState :: term()} |
	  {stop, Reason :: term(), NewState :: term()}.



handle_call({call,PhosconAppl,DeviceName,Function, Args}, _From, State) ->
    Result=try lib_zigbee_server:call(PhosconAppl,DeviceName,Function, Args) of
	       {ok,R}->
		   {ok,R};
	       {error,ErrorR}->
		   {error,["M:F [A]) with reason", lib_zigbee_service,call,[PhosconAppl,DeviceName,Function, Args],"Reason=", ErrorR]}
	   catch
	       Event:Reason:Stacktrace ->
		   {error,[#{event=>Event,
			     module=>?MODULE,
			     function=>?FUNCTION_NAME,
			     line=>?LINE,
			     args=>[PhosconAppl,DeviceName,Function, Args],
			     reason=>Reason,
			     stacktrace=>[Stacktrace]}]}
	   end,
    Reply=case Result of
	      {ok,AllMaps}->
		  {ok,AllMaps};
	      {error,ErrorReason}->
		  {error,ErrorReason}
	  end,
    {reply, Reply,State};


handle_call({get_all_raw,PhosconApp}, _From, State) ->
    Result=try lib_zigbee_server:get_all_raw(PhosconApp) of
	       {ok,R}->
		   {ok,R};
	       {error,ErrorR}->
		   {error,["M:F [A]) with reason", lib_zigbee_service,get_all,[],"Reason=", ErrorR]}
	   catch
	       Event:Reason:Stacktrace ->
		   {error,[#{event=>Event,
			     module=>?MODULE,
			     function=>?FUNCTION_NAME,
			     line=>?LINE,
			     args=>[],
			     reason=>Reason,
			     stacktrace=>[Stacktrace]}]}
	   end,
    Reply=case Result of
	      {ok,AllMaps}->
		  {ok,AllMaps};
	      {error,ErrorReason}->
		  {error,ErrorReason}
	  end,
    {reply, Reply,State};

handle_call({get_all,PhosconApp,DeviceType}, _From, State) ->
    Result=try lib_zigbee_server:get_all(PhosconApp,DeviceType) of
	       {ok,R}->
		   {ok,R};
	       {error,ErrorR}->
		   {error,["M:F [A]) with reason", lib_zigbee_service,get_all,[],"Reason=", ErrorR]}
	   catch
	       Event:Reason:Stacktrace ->
		   {error,[#{event=>Event,
			     module=>?MODULE,
			     function=>?FUNCTION_NAME,
			     line=>?LINE,
			     args=>[],
			     reason=>Reason,
			     stacktrace=>[Stacktrace]}]}
	   end,
    Reply=case Result of
	      {ok,AllMaps}->
		  {ok,AllMaps};
	      {error,ErrorReason}->
		  {error,ErrorReason}
	  end,
    {reply, Reply,State};


handle_call({get_all,PhosconApp}, _From, State) ->
    Result=try lib_zigbee_server:get_all(PhosconApp) of
	       {ok,R}->
		   {ok,R};
	       {error,ErrorR}->
		   {error,["M:F [A]) with reason", lib_zigbee_service,get_all,[],"Reason=", ErrorR]}
	   catch
	       Event:Reason:Stacktrace ->
		   {error,[#{event=>Event,
			     module=>?MODULE,
			     function=>?FUNCTION_NAME,
			     line=>?LINE,
			     args=>[],
			     reason=>Reason,
			     stacktrace=>[Stacktrace]}]}
	   end,
    Reply=case Result of
	      {ok,AllMaps}->
		  {ok,AllMaps};
	      {error,ErrorReason}->
		  {error,ErrorReason}
	  end,
    {reply, Reply,State};


handle_call({get_all}, _From, State) ->
    Result=try lib_zigbee_server:get_all() of
	       {ok,R}->
		   {ok,R};
	       {error,ErrorR}->
		   {error,["M:F [A]) with reason", lib_zigbee_service,get_all,[],"Reason=", ErrorR]}
	   catch
	       Event:Reason:Stacktrace ->
		   {error,[#{event=>Event,
			     module=>?MODULE,
			     function=>?FUNCTION_NAME,
			     line=>?LINE,
			     args=>[],
			     reason=>Reason,
			     stacktrace=>[Stacktrace]}]}
	   end,
    Reply=case Result of
	      {ok,AllMaps}->
		  {ok,AllMaps};
	      {error,ErrorReason}->
		  {error,ErrorReason}
	  end,
    {reply, Reply,State};



%%----- TemplateCode ---------------------------------------------------------------

handle_call({template_call,Args}, _From, State) ->
    Result=try erlang:apply(erlang,date,[])  of
	      {Y,M,D}->
		   {ok,Y,M,D};
	      {error,ErrorR}->
		   {error,["M:F [A]) with reason",erlang,date,[erlang,date,[]],"Reason=", ErrorR]}
	   catch
	       Event:Reason:Stacktrace ->
		   {error,[#{event=>Event,
			     module=>?MODULE,
			     function=>?FUNCTION_NAME,
			     line=>?LINE,
			     args=>Args,
			     reason=>Reason,
			     stacktrace=>[Stacktrace]}]}
	   end,
    Reply=case Result of
	      {ok,Year,Month,Day}->
		  NewState=State,
		  {ok,Year,Month,Day};
	      {error,ErrorReason}->
		  NewState=State,
		  {error,ErrorReason}
	  end,
    {reply, Reply,NewState};

%%----- Admin ---------------------------------------------------------------

handle_call({ping}, _From, State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call(UnMatchedSignal, From, State) ->
   ?LOG_WARNING("Unmatched signal",[UnMatchedSignal]),
    io:format("unmatched_signal ~p~n",[{UnMatchedSignal, From,?MODULE,?LINE}]),
    Reply = {error,[unmatched_signal,UnMatchedSignal, From]},
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%% @end
%%--------------------------------------------------------------------


handle_cast({template_cast,Args}, State) ->
    Result=try erlang:apply(erlang,date,[])  of
	      {Year,Month,Day}->
		   {ok,Year,Month,Day};
	      {error,ErrorR}->
		   {error,["M:F [A]) with reason",erlang,date,[erlang,date,[]],"Reason=", ErrorR]}
	   catch
	       Event:Reason:Stacktrace ->
		   {error,[#{event=>Event,
			     module=>?MODULE,
			     function=>?FUNCTION_NAME,
			     line=>?LINE,
			     args=>Args,
			     reason=>Reason,
			     stacktrace=>[Stacktrace]}]}
	   end,
    case Result of
	{ok,_Year,_Month,_Day}->
	    NewState=State;
	{error,_ErrorReason}->
	    NewState=State
    end,
    {noreply, NewState};



handle_cast({stop}, State) ->
    
    {stop,normal,ok,State};

handle_cast(UnMatchedSignal, State) ->
    ?LOG_WARNING("Unmatched signal",[UnMatchedSignal]),
    io:format("unmatched_signal ~p~n",[{UnMatchedSignal,?MODULE,?LINE}]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%% @end
%%--------------------------------------------------------------------
-spec handle_info(Info :: timeout() | term(), State :: term()) ->
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: normal | term(), NewState :: term()}.
handle_info(timeout, State) ->

    ?LOG_NOTICE("Server started ",[?MODULE]),
    {noreply, State};

handle_info(Info, State) ->
    ?LOG_WARNING("Unmatched signal",[Info]),
    io:format("unmatched_signal ~p~n",[{Info,?MODULE,?LINE}]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason :: normal | shutdown | {shutdown, term()} | term(),
		State :: term()) -> any().
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%% @end
%%--------------------------------------------------------------------
-spec code_change(OldVsn :: term() | {down, term()},
		  State :: term(),
		  Extra :: term()) -> {ok, NewState :: term()} |
	  {error, Reason :: term()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called for changing the form and appearance
%% of gen_server status when it is returned from sys:get_status/1,2
%% or when it appears in termination error logs.
%% @end
%%--------------------------------------------------------------------
-spec format_status(Opt :: normal | terminate,
		    Status :: list()) -> Status :: term().
format_status(_Opt, Status) ->
    Status.

%%%===================================================================
%%% Internal functions
%%%===================================================================
